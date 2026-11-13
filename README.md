# ExOura

[![Hex.pm](https://img.shields.io/hexpm/v/ex_oura)](https://hex.pm/packages/ex_oura) 
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ex_oura/)
[![Build Status](https://github.com/tgrk/ex_oura/actions/workflows/elixir.yaml/badge.svg)](https://github.com/tgrk/ex_oura/actions)
[![Coverage Status](https://coveralls.io/repos/github/tgrk/ex_oura/badge.svg)](https://coveralls.io/github/tgrk/ex_oura)
[![Last Updated](https://img.shields.io/github/last-commit/tgrk/ex_oura.svg)](https://github.com/tgrk/ex_oura/commits/master)
[![License](https://img.shields.io/hexpm/l/ex_oura.svg)](https://github.com/tgrk/ex_oura/blob/master/LICENSE)


**An Elixir client for the Oura API, leveraging the OpenAPI v1.42 specification.**

An Elixir library for interacting with the [Oura API](https://cloud.ouraring.com/v2/docs) with a base client generated using [OpenAPI Code Generator](https://github.com/aj-foster/open-api-generator) from [Oura OpenAPI specs v1.42](https://cloud.ouraring.com/v2/static/json/openapi-1.42.json). It supports Oura collection APIs including activity, readiness, sleep, workouts, heart-rate time series, and webhook management.

## Features

- **OAuth2 authentication** support (recommended approach), with automatic token refresh
- Fetch data such as activity, readiness, and sleep metrics
- Pagination helpers that fetch or stream every page
- Client-side rate limiting and automatic retries

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
   - Webhook subscription calls always read `OURA_CLIENT_ID` and `OURA_CLIENT_SECRET`
     from the environment, so set them when you manage webhooks.
   - `timeout`, `rate_limiting` and `retry` are read at compile time. After changing them,
     run `mix deps.compile ex_oura --force`.

3. **Start the processes**

   ExOura.Client is a named process and must be running before any API call;
   otherwise calls return `{:error, :client_not_ready}`. `ExOura.RateLimiter` is optional.
   ExOura has no application callback, so add both to your own supervisor:

   ```elixir
   # tokens is the map returned by ExOura.get_token/2; it includes expires_at,
   # which the client needs to refresh the access token automatically
   children = [
     ExOura.RateLimiter,
     {ExOura.Client, tokens}
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
      store_user_tokens(current_user(conn), tokens)

      # Point the running client at the new tokens
      :ok = ExOura.set_auth_config(tokens)

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

### Token Refresh Handling

When the client is given a token map with `expires_at` (as returned by `ExOura.get_token/2`),
it refreshes an expired access token itself. To refresh explicitly and keep your stored
tokens current:

```elixir
defmodule MyApp.OuraService do
  def ensure_valid_tokens(user) do
    tokens = get_user_tokens(user)

    if ExOura.token_expired?(tokens) do
      case ExOura.refresh_token(tokens.refresh_token) do
        {:ok, new_tokens} ->
          update_user_tokens(user, new_tokens)
          :ok = ExOura.set_auth_config(new_tokens)
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

- When **enabled** and `ExOura.RateLimiter` is running, the client tracks limits,
  parses `X-RateLimit-*` response headers, and delays requests before a limit is hit.
- When **disabled** or not running, nothing is tracked; `429` responses are still retried.

```elixir
status = ExOura.RateLimiter.get_status()
IO.puts("Daily remaining: #{status.remaining}")
IO.puts("Per-minute remaining: #{status.per_minute_remaining}")
```

Retries use Req's built-in retry with exponential backoff and jitter. Server errors (5xx),
timeouts (408), rate limits (429) and network errors are retried; other 4xx errors are not.
Only `retry: [max_retries: n]` is configurable (default 3).

## License

This project is licensed under the MIT License.
