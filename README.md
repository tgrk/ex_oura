# ExOura

[![Hex.pm](https://img.shields.io/hexpm/v/ex_oura)](https://hex.pm/packages/ex_oura) 
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ex_oura/)
[![Build Status](https://github.com/tgrk/ex_oura/actions/workflows/elixir.yaml/badge.svg)](https://github.com/tgrk/ex_oura/actions)
[![Coverage Status](https://coveralls.io/repos/github/tgrk/ex_oura/badge.svg)](https://coveralls.io/github/tgrk/ex_oura)
[![Last Updated](https://img.shields.io/github/last-commit/tgrk/ex_oura.svg)](https://github.com/tgrk/ex_oura/commits/master)
[![License](https://img.shields.io/hexpm/l/ex_oura.svg)](https://github.com/tgrk/ex_oura/blob/master/LICENSE)


**An Elixir client for the Oura API, leveraging the OpenAPI v1.43 specification.**

An Elixir library for interacting with the [Oura API](https://cloud.ouraring.com/v2/docs) with a base client generated using [OpenAPI Code Generator](https://github.com/aj-foster/open-api-generator) from [Oura OpenAPI specs v1.43](https://cloud.ouraring.com/v2/static/json/openapi-1.43.json). It supports Oura collection APIs including activity, readiness, sleep, workouts, heart-rate time series, and webhook management.

## Features

- **OAuth2 authentication** support (recommended approach), with automatic token refresh
- Fetch data such as activity, readiness, and sleep metrics
- Pagination helpers that fetch or stream every page
- Client-side rate limiting and automatic retries for GET requests

## OpenAPI 1.43 compatibility

The public `ExOura` functions and response structs remain compatible. Oura now requires a
`User-Agent` header identifying your application on every request and may reject requests
without one. ExOura sends `ex_oura/<version>` by default; set your own with
`config :ex_oura, user_agent: "YourAppName/1.0"`.

OpenAPI 1.42 added `live_third_party_heart_rate` and `live_oura_heart_rate` workout sources
and the optional `heart_health` OAuth2 scope (see [OAuth2 Integration](#oauth2-integration)).

Oura no longer lists `meal` as a supported webhook subscription data type. Sleep
`ring_id` is deprecated and now returns `nil`; the field remains in the response struct.

## Installation

Add `ex_oura` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_oura, "~> 4.0"}
  ]
end
```

## API Module Reference

ExOura provides dedicated modules for each type of Oura data. Every function is also available on the `ExOura` facade (for example `ExOura.multiple_daily_sleep/4`).

### Core Data Modules

- **`ExOura.DailyActivity`** - Daily activity metrics (steps, calories, activity score)
- **`ExOura.DailySleep`** - Sleep data (sleep score, stages, duration, quality)
- **`ExOura.DailyReadiness`** - Readiness scores and recovery metrics
- **`ExOura.Workout`** - Exercise sessions and workout data
- **`ExOura.PersonalInfo`** - User demographics and physical information

### Specialized Data Modules

- **`ExOura.HeartRate`** - Time-series heart rate data
- **`ExOura.DailySp02`** - Blood oxygen saturation data during sleep
- **`ExOura.DailyStress`** - Daily stress levels and patterns
- **`ExOura.DailyResilience`** - Resilience scores and stress recovery
- **`ExOura.DailyCardiovascularAge`** - Cardiovascular age estimates
- **`ExOura.EnhancedTag`** - User tags and annotations (recommended)
- **`ExOura.Tag`** - Legacy tag system (deprecated by Oura)
- **`ExOura.Session`** - Guided sessions and breathing exercises
- **`ExOura.Sleep`** - Detailed sleep session data
- **`ExOura.SleepTime`** - Sleep timing preferences
- **`ExOura.RestModePeriod`** - Rest mode periods
- **`ExOura.RingConfiguration`** - Ring hardware and firmware details
- **`ExOura.RingBatteryLevel`** - Time-series ring battery level events
- **`ExOura.Vo2Max`** - VO2 Max measurements
- **`ExOura.WebhookSubscription`** - Webhook management

### Core Infrastructure Modules

- **ExOura.Client** - Base HTTP client with authentication
- **`ExOura.OAuth2`** - OAuth2 flow management
- **`ExOura.Pagination`** - Automatic pagination handling
- **`ExOura.RateLimiter`** - API rate limit management

## Getting Started

1. **Register Your Application** (OAuth2 - Recommended)
   - Visit [Oura OAuth Applications](https://cloud.ouraring.com/oauth/applications)
   - Create a new application and note your client credentials
   - Configure your redirect URI (it has to be a valid one not `http://localhost` as you will get 403 error)

2. **Configure Your Application**
   ```elixir
   # In config/config.exs
   config :ex_oura,
     timeout: 10_000,
     user_agent: "YourAppName/1.0",
     oauth2: [
       client_id: "your_client_id",
       client_secret: "your_client_secret",
       redirect_uri: "https://yourapp.com/oauth/callback"
     ],
     rate_limiting: [
       enabled: true,
       daily_limit: 5_000,
       per_minute_limit: 300
     ],
     retry: [
       max_retries: 3
     ]
   ```

   - Any missing `oauth2` key falls back to the `OURA_CLIENT_ID`, `OURA_CLIENT_SECRET`
     and `OURA_REDIRECT_URI` environment variables.
   - Webhook subscription calls send the same `client_id` and `client_secret`, so set them
     when you manage webhooks.
   - `timeout`, `rate_limiting` and `retry` are read at compile time. After changing them,
     run `mix deps.compile ex_oura --force`.

3. **Start the processes**

   `ExOura.Client` is a named process and must be running before any API call that does not
   pass `access_token:` (see [Multiple Users](#multiple-users)); otherwise calls return
   `{:error, :client_not_ready}`. `ExOura.RateLimiter` is optional.
   ExOura has no application callback, so add both to your own supervisor:

   ```elixir
   # tokens is the map returned by ExOura.get_token/2; it includes expires_at,
   # which the client needs to refresh the access token automatically.
   # on_refresh persists each rotated (single-use) refresh token.
   children = [
     ExOura.RateLimiter,
     {ExOura.Client, Map.put(tokens, :on_refresh, &MyApp.Tokens.save/1)}
   ]
   ```

## OAuth2 Integration

Default scopes are `personal` and `daily`; `ExOura.available_scopes/0` lists them all.
Request other scopes explicitly, e.g. `ExOura.authorization_url(scopes: ["daily", "heart_health"])`.
Existing grants need new user consent to gain a scope.

### Basic OAuth2 Flow

```elixir
defmodule MyApp.OuraController do
  use MyApp, :controller

  # Step 1: Redirect user to Oura for authorization
  def authorize(conn, _params) do
    state = generate_csrf_token() # Your CSRF token generation
    store_state_in_session(conn, state) # Store for verification

    auth_url = ExOura.authorization_url([
      scopes: ["daily", "heartrate", "personal"],
      state: state
    ])

    redirect(conn, external: auth_url)
  end

  # Step 2: Handle the OAuth callback
  def callback(conn, %{"code" => code, "state" => state}) do
    with {:ok, stored_state} <- get_state_from_session(conn),
         true <- secure_compare(state, stored_state),
         {:ok, tokens} <- ExOura.get_token(code) do
      # Store tokens securely (database, encrypted session, etc.)
      # and pass `access_token:` on each call for this user (see below)
      store_user_tokens(current_user(conn), tokens)

      redirect(conn, to: "/dashboard")
    else
      _ ->
        conn
        |> put_flash(:error, "OAuth authorization failed")
        |> redirect(to: "/")
    end
  end
end
```

### Multiple Users

The shared `ExOura.Client` process holds **one** account's token. For apps with many users,
pass that user's token on each call with `access_token:`. It is used instead of the shared
token, and works even when `ExOura.Client` is not started. Refresh it yourself with
`ExOura.refresh_token/1` (see below).

```elixir
ExOura.multiple_daily_activity(~D[2025-01-01], ~D[2025-01-31], nil, access_token: tokens.access_token)
ExOura.all_daily_sleep(~D[2025-01-01], ~D[2025-01-31], access_token: tokens.access_token)
```

### Token Refresh Handling

When you start the shared `ExOura.Client` with a refresh token and `expires_at`, it refreshes
the access token on its own shortly before it expires. Oura refresh tokens are **single-use**,
so pass `on_refresh:` to save every new token pair; otherwise the refresh token you stored
stops working after the first refresh. The callback runs inside the client process: keep it
quick and do not call ExOura from it. If it raises, a warning is logged and the client keeps
the new tokens.

```elixir
ExOura.Client.start_link(
  access_token: tokens.access_token,
  refresh_token: tokens.refresh_token,
  expires_at: tokens.expires_at,
  on_refresh: fn new_tokens -> MyApp.Tokens.save(user, new_tokens) end
)
```

With per-call `access_token:` (multiple users), refresh tokens yourself:

```elixir
defmodule MyApp.OuraService do
  def ensure_valid_tokens(user) do
    tokens = get_user_tokens(user)

    if ExOura.token_expired?(tokens) do
      case ExOura.refresh_token(tokens.refresh_token) do
        {:ok, new_tokens} ->
          update_user_tokens(user, new_tokens)
          {:ok, new_tokens}

        {:error, _reason} ->
          # Token refresh failed - user needs to re-authorize
          {:error, :reauthorization_required}
      end
    else
      {:ok, tokens}
    end
  end
end
```

## Quick Reference

```elixir
{:ok, activities} = ExOura.multiple_daily_activity(~D[2025-01-01], ~D[2025-01-31])
{:ok, sleep_data} = ExOura.multiple_daily_sleep(~D[2025-01-01], ~D[2025-01-31])
{:ok, workouts} = ExOura.multiple_workout(~D[2025-01-01], ~D[2025-01-31])
{:ok, personal_info} = ExOura.single_personal_info()

activities.data |> Enum.each(&IO.inspect/1)
```

## Pagination Support

For large date ranges, the API returns paginated results. ExOura provides convenient functions to automatically handle pagination:

```elixir
# Fetch ALL daily activity data across multiple pages
{:ok, all_activities} = ExOura.all_daily_activity(~D[2024-01-01], ~D[2024-12-31])

# Stream data for memory-efficient processing of large datasets
ExOura.stream_daily_activity(~D[2024-01-01], ~D[2024-12-31])
|> Stream.filter(& &1.score > 80)
|> Enum.take(10)

# Available pagination helpers
ExOura.all_daily_activity/3     # All daily activity data
ExOura.all_daily_readiness/3    # All daily readiness data  
ExOura.all_daily_sleep/3        # All daily sleep data
ExOura.all_workouts/3           # All workout data
ExOura.all_sleep/3              # All sleep data
ExOura.stream_daily_activity/3  # Stream daily activity data
ExOura.stream_workouts/3        # Stream workout data
```

### Pagination Options

`all_*` helpers stop after `max_pages` (default 100) and return
`{:error, {:max_pages_exceeded, max_pages}}`:

```elixir
{:ok, activities} = ExOura.all_daily_activity(~D[2024-01-01], ~D[2024-12-31], max_pages: 10)

# Manual pagination if you need more control
{:ok, page1} = ExOura.multiple_daily_activity(~D[2024-01-01], ~D[2024-01-31])
{:ok, page2} = ExOura.multiple_daily_activity(~D[2024-01-01], ~D[2024-01-31], page1.next_token)
```

## Rate Limiting and Retries

Rate limiting is enabled by default with the Oura API limits (5000 requests/day,
300 requests/minute) and is configured under `rate_limiting` (see Getting Started).

- When **enabled** and `ExOura.RateLimiter` is running, the client tracks limits, reads
  `x-ratelimit-*` response headers when present, and adds a short (≤200 ms) delay when few
  per-minute requests remain. Once a known limit is used up, calls return
  `{:error, {:rate_limited, seconds}}` right away without calling the API.
- When **disabled** or not running, nothing is tracked; `429` responses to GET requests are
  still retried.

```elixir
status = ExOura.RateLimiter.get_status()
IO.puts("Daily remaining: #{status.remaining}")
IO.puts("Per-minute remaining: #{status.per_minute_remaining}")
```

Retries use Req's built-in `retry: :safe_transient`: GET requests are retried on 408, 429
and 5xx responses and on transient network errors, honoring `Retry-After`, otherwise with
exponential backoff and jitter. POST, PUT and DELETE (webhook subscriptions) are never
retried. Only `retry: [max_retries: n]` is configurable (default 3).

## License

This project is licensed under the MIT License.
