# ExOura

[![Hex.pm](https://img.shields.io/hexpm/v/ex_oura)](https://hex.pm/packages/ex_oura) 
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ex_oura/)
[![Build Status](https://github.com/tgrk/ex_oura/actions/workflows/elixir.yaml/badge.svg)](https://github.com/tgrk/ex_oura/actions)
[![Coverage Status](https://coveralls.io/repos/github/tgrk/ex_oura/badge.svg)](https://coveralls.io/github/tgrk/ex_oura)
[![Last Updated](https://img.shields.io/github/last-commit/tgrk/ex_oura.svg)](https://github.com/tgrk/ex_oura/commits/master)
[![License](https://img.shields.io/hexpm/l/ex_oura.svg)](https://github.com/sticksnleaves/ex_oura/blob/master/LICENSE.md)


**An Elixir client for the Oura API, leveraging the OpenAPI v1.27 specification.**

An Elixir library for interacting with the [Oura API](https://cloud.ouraring.com/v2/docs) with a base client generated using [OpenAPI Code Generator](https://github.com/aj-foster/open-api-generator) from [Oura OpenAPI specs v1.27](https://cloud.ouraring.com/v2/static/json/openapi-1.27.json). It supports basic functionality for tertrieving data from Oura, such as activity, readiness, and sleep metrics.

## Features

- **OAuth2 authentication** support (recommended approach)
- **Personal Access Token** support (deprecated - to be removed by end of 2025)
- Fetch data such as activity, readiness, and sleep metrics 
- Built on the robust Elixir ecosystem 
- Compatible with OpenAPI v1.27

## Installation

Add `ex_oura` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_oura, "~> 2.0.0"}
  ]
end
```

## Developer Integration Guide

### Getting Started

1. **Register Your Application** (OAuth2 - Recommended)
   - Visit [Oura OAuth Applications](https://cloud.ouraring.com/oauth/applications)
   - Create a new application and note your client credentials
   - Configure your redirect URI

2. **Install ExOura**
   ```elixir
   # In mix.exs
   def deps do
     [
       {:ex_oura, "~> 2.0.0"}
     ]
   end
   ```

3. **Configure Your Application**
   ```elixir
   # In config/config.exs
   config :ex_oura,
     oauth2: [
       client_id: "your_client_id",
       client_secret: "your_client_secret",
       redirect_uri: "https://yourapp.com/oauth/callback"
     ],
     rate_limiting: [
       enabled: true,
       daily_limit: 5000,
       per_minute_limit: 300
     ]
   ```

### OAuth2 Integration Examples

#### Basic OAuth2 Flow

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
      
      # Start the ExOura client with tokens
      {:ok, _client} = ExOura.Client.start_link([
        access_token: tokens.access_token,
        refresh_token: tokens.refresh_token
      ])

      redirect(conn, to: "/dashboard")
    else
      {:error, reason} ->
        conn
        |> put_flash(:error, "OAuth authorization failed: #{inspect(reason)}")
        |> redirect(to: "/")
    end
  end
end
```

#### Token Refresh Handling

```elixir
defmodule MyApp.OuraService do
  @doc "Ensures we have valid tokens before making API calls"
  def ensure_valid_tokens(user) do
    tokens = get_user_tokens(user)
    
    if ExOura.token_expired?(tokens) do
      case ExOura.refresh_token(tokens.refresh_token) do
        {:ok, new_tokens} ->
          update_user_tokens(user, new_tokens)
          restart_client_with_tokens(new_tokens)
          {:ok, new_tokens}
        
        {:error, reason} ->
          # Token refresh failed - user needs to re-authorize
          {:error, :reauthorization_required}
      end
    else
      {:ok, tokens}
    end
  end
  
  defp restart_client_with_tokens(tokens) do
    # Restart client with new tokens
    ExOura.Client.start_link([
      access_token: tokens.access_token,
      refresh_token: tokens.refresh_token
    ])
  end
end
```

### Data Retrieval Examples

#### Comprehensive Health Dashboard

```elixir
defmodule MyApp.HealthDashboard do
  @doc "Fetches comprehensive health data for dashboard"
  def fetch_user_health_data(user, date_range) do
    with {:ok, _tokens} <- MyApp.OuraService.ensure_valid_tokens(user) do
      {start_date, end_date} = date_range
      
      # Fetch data in parallel using Task.async
      tasks = [
        Task.async(fn -> ExOura.all_daily_activity(start_date, end_date) end),
        Task.async(fn -> ExOura.all_daily_sleep(start_date, end_date) end),
        Task.async(fn -> ExOura.all_workouts(start_date, end_date) end),
        Task.async(fn -> ExOura.single_personal_info() end)
      ]
      
      # Wait for all tasks to complete
      [activity_result, sleep_result, workout_result, personal_result] = 
        Task.await_many(tasks, 30_000)
      
      case {activity_result, sleep_result, workout_result, personal_result} do
        {{:ok, activities}, {:ok, sleep_data}, {:ok, workouts}, {:ok, personal_info}} ->
          {:ok, %{
            activities: activities,
            sleep: sleep_data,
            workouts: workouts,
            personal_info: personal_info,
            summary: generate_health_summary(activities, sleep_data, workouts)
          }}
        
        _ ->
          {:error, :data_fetch_failed}
      end
    end
  end
  
  defp generate_health_summary(activities, sleep_data, workouts) do
    %{
      avg_steps: avg_field(activities, :steps),
      avg_sleep_score: avg_field(sleep_data, :score),
      total_workouts: length(workouts),
      avg_workout_duration: avg_field(workouts, :duration)
    }
  end
  
  defp avg_field(data, field) when is_list(data) do
    case data do
      [] -> 0
      items ->
        sum = items |> Enum.map(&Map.get(&1, field, 0)) |> Enum.sum()
        sum / length(items)
    end
  end
end
```

#### Streaming Large Datasets

```elixir
defmodule MyApp.DataAnalyzer do
  @doc "Analyzes large datasets using streaming for memory efficiency"
  def analyze_yearly_activity(user, year) do
    start_date = Date.new!(year, 1, 1)
    end_date = Date.new!(year, 12, 31)
    
    with {:ok, _tokens} <- MyApp.OuraService.ensure_valid_tokens(user) do
      results = ExOura.stream_daily_activity(start_date, end_date)
      |> Stream.filter(&(&1.score > 0))  # Valid scores only
      |> Stream.map(&extract_activity_metrics/1)
      |> Enum.reduce(%{total_steps: 0, active_days: 0, high_activity_days: 0}, &accumulate_metrics/2)
      
      {:ok, %{
        year: year,
        total_steps: results.total_steps,
        active_days: results.active_days,
        high_activity_days: results.high_activity_days,
        avg_daily_steps: results.total_steps / max(results.active_days, 1)
      }}
    end
  end
  
  defp extract_activity_metrics(activity) do
    %{
      steps: activity.steps || 0,
      high_activity: (activity.score || 0) >= 80
    }
  end
  
  defp accumulate_metrics(day_metrics, acc) do
    %{
      total_steps: acc.total_steps + day_metrics.steps,
      active_days: acc.active_days + 1,
      high_activity_days: acc.high_activity_days + if(day_metrics.high_activity, do: 1, else: 0)
    }
  end
end
```

#### Error Handling Best Practices

```elixir
defmodule MyApp.OuraAPI do
  @doc "Robust API call with comprehensive error handling"
  def safe_fetch_sleep_data(user, date_range, opts \\ []) do
    max_retries = Keyword.get(opts, :max_retries, 3)
    
    with_retry(fn -> fetch_sleep_data(user, date_range) end, max_retries)
  end
  
  defp fetch_sleep_data(user, {start_date, end_date}) do
    case MyApp.OuraService.ensure_valid_tokens(user) do
      {:ok, _tokens} ->
        ExOura.multiple_daily_sleep(start_date, end_date)
      
      {:error, :reauthorization_required} ->
        {:error, :user_needs_reauth}
        
      {:error, reason} ->
        {:error, reason}
    end
  end
  
  defp with_retry(func, retries_left) when retries_left > 0 do
    case func.() do
      {:ok, result} -> 
        {:ok, result}
      
      {:error, %{status: status}} when status in [429, 500, 502, 503, 504] ->
        # Retryable errors
        :timer.sleep(exponential_backoff(3 - retries_left))
        with_retry(func, retries_left - 1)
      
      {:error, reason} ->
        # Non-retryable error
        {:error, reason}
    end
  end
  
  defp with_retry(func, 0), do: func.()
  
  defp exponential_backoff(attempt) do
    base_delay = 1000  # 1 second
    :rand.uniform(base_delay * :math.pow(2, attempt)) |> round()
  end
end
```

### Production Considerations

#### Rate Limiting Management

```elixir
# Start rate limiter in your application supervisor
children = [
  {ExOura.RateLimiter, []},
  # ... other children
]

# Monitor rate limit status
defmodule MyApp.RateLimitMonitor do
  use GenServer
  
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end
  
  def init(state) do
    # Check rate limits every minute
    :timer.send_interval(60_000, :check_rate_limits)
    {:ok, state}
  end
  
  def handle_info(:check_rate_limits, state) do
    case ExOura.RateLimiter.get_status() do
      %{remaining: remaining} when remaining < 100 ->
        # Alert when approaching daily limit
        Logger.warning("Oura API daily limit approaching: #{remaining} requests remaining")
      
      %{per_minute_remaining: per_min} when per_min < 10 ->
        # Alert when approaching per-minute limit  
        Logger.warning("Oura API per-minute limit approaching: #{per_min} requests remaining")
      
      _ ->
        :ok
    end
    
    {:noreply, state}
  end
end
```

#### Background Data Sync

```elixir
defmodule MyApp.OuraSync do
  use Oban.Worker, queue: :oura_sync, max_attempts: 3
  
  @doc "Background job to sync user's Oura data"
  def perform(%Oban.Job{args: %{"user_id" => user_id, "sync_date" => sync_date}}) do
    user = MyApp.Accounts.get_user!(user_id)
    date = Date.from_iso8601!(sync_date)
    
    with {:ok, _tokens} <- MyApp.OuraService.ensure_valid_tokens(user),
         {:ok, data} <- sync_user_data_for_date(user, date) do
      
      MyApp.HealthData.store_user_data(user, date, data)
      :ok
    else
      {:error, :user_needs_reauth} ->
        # Schedule notification to user
        MyApp.Notifications.schedule_reauth_reminder(user)
        {:snooze, 3600}  # Retry in 1 hour
      
      {:error, reason} ->
        Logger.error("Failed to sync Oura data for user #{user_id}: #{inspect(reason)}")
        {:error, reason}
    end
  end
  
  defp sync_user_data_for_date(user, date) do
    # Fetch yesterday's data (typically available by 10 AM)
    with {:ok, activity} <- ExOura.multiple_daily_activity(date, date),
         {:ok, sleep} <- ExOura.multiple_daily_sleep(date, date),
         {:ok, workouts} <- ExOura.multiple_workout(date, date) do
      
      {:ok, %{
        activity: List.first(activity.data),
        sleep: List.first(sleep.data), 
        workouts: workouts.data
      }}
    end
  end
end
```

## API Module Reference

ExOura provides dedicated modules for each type of Oura data:

### Core Data Modules

- **`ExOura.DailyActivity`** - Daily activity metrics (steps, calories, activity score)
- **`ExOura.DailySleep`** - Sleep data (sleep score, stages, duration, quality)
- **`ExOura.DailyReadiness`** - Readiness scores and recovery metrics
- **`ExOura.Workout`** - Exercise sessions and workout data
- **`ExOura.PersonalInfo`** - User demographics and physical information

### Specialized Data Modules

- **`ExOura.HeartRate`** - Time-series heart rate data (Gen 3+ only)
- **`ExOura.DailySp02`** - Blood oxygen saturation data during sleep
- **`ExOura.DailyStress`** - Daily stress levels and patterns
- **`ExOura.DailyResilience`** - Resilience scores and stress recovery
- **`ExOura.EnhancedTag`** - User tags and annotations (recommended)
- **`ExOura.Tag`** - Legacy tag system (deprecated by Oura)
- **`ExOura.Session`** - Guided sessions and breathing exercises
- **`ExOura.Sleep`** - Detailed sleep session data
- **`ExOura.SleepTime`** - Sleep timing preferences
- **`ExOura.Vo2Max`** - VO2 Max measurements
- **`ExOura.WebhookSubscription`** - Webhook management

### Core Infrastructure Modules

- **`ExOura.Client`** - Base HTTP client with authentication
- **`ExOura.OAuth2`** - OAuth2 flow management
- **`ExOura.Pagination`** - Automatic pagination handling
- **`ExOura.RateLimiter`** - API rate limit management

### Quick Reference

```elixir
# Most common operations
{:ok, activities} = ExOura.multiple_daily_activity(~D[2025-01-01], ~D[2025-01-31])
{:ok, sleep_data} = ExOura.multiple_daily_sleep(~D[2025-01-01], ~D[2025-01-31])
{:ok, workouts} = ExOura.multiple_workout(~D[2025-01-01], ~D[2025-01-31])
{:ok, personal_info} = ExOura.single_personal_info()

# Pagination helpers (automatically handles multiple pages)
{:ok, all_activities} = ExOura.all_daily_activity(~D[2024-01-01], ~D[2024-12-31])
{:ok, all_sleep} = ExOura.all_daily_sleep(~D[2024-01-01], ~D[2024-12-31])

# Memory-efficient streaming for large datasets
ExOura.stream_daily_activity(~D[2024-01-01], ~D[2024-12-31])
|> Stream.filter(&(&1.score > 80))
|> Enum.take(100)
```

## Pagination Support

For large date ranges, the API returns paginated results. ExOura provides convenient functions to automatically handle pagination:

```elixir
# Fetch ALL daily activity data across multiple pages
{:ok, all_activities} = ExOura.all_daily_activity(~D[2024-01-01], ~D[2024-12-31])
IO.inspect(length(all_activities))  # All activities for the year

# Fetch ALL workouts across multiple pages  
{:ok, all_workouts} = ExOura.all_workouts(~D[2024-01-01], ~D[2024-12-31])

# Stream data for memory-efficient processing of large datasets
ExOura.stream_daily_activity(~D[2024-01-01], ~D[2024-12-31])
|> Stream.filter(& &1.score > 80)
|> Stream.take(10)
|> Enum.to_list()

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

You can control pagination behavior with options:

```elixir
# Limit maximum pages to prevent runaway requests
{:ok, activities} = ExOura.all_daily_activity(
  ~D[2024-01-01], 
  ~D[2024-12-31], 
  [max_pages: 10]
)

# Manual pagination if you need more control
{:ok, page1} = ExOura.multiple_daily_activity(~D[2024-01-01], ~D[2024-01-31])
{:ok, page2} = ExOura.multiple_daily_activity(~D[2024-01-01], ~D[2024-01-31], page1.next_token)
```

### Rate Limiting and Retry Logic

ExOura automatically handles Oura API rate limits and implements intelligent retry logic:

**Configuration Options:**

Rate limiting is enabled by default with the standard Oura API limits. You can customize or disable it:

```elixir
config :ex_oura,
  rate_limiting: [
    enabled: true,          # Set to false to disable rate limiting entirely
    daily_limit: 5000,      # Customize daily limit (default: 5000)
    per_minute_limit: 300   # Customize per-minute limit (default: 300)
  ]
```

**Behavior:**
- When **enabled** (default): Tracks and enforces rate limits proactively
- When **disabled**: No rate limit tracking, but still handles API rate limit responses
- Automatic parsing of rate limit headers from API responses
- Uses Req's built-in retry logic with exponential backoff and jitter

**Usage:**

```elixir
# Start the rate limiter (optional - provides better rate limit management)
{:ok, _pid} = ExOura.RateLimiter.start_link()

# All API requests automatically:
# - Respect rate limits (5000/day, 300/minute) if enabled
# - Parse rate limit headers from responses
# - Use Req's built-in retry with exponential backoff
# - Handle network errors and server errors gracefully

# Example: This will automatically retry on server errors and rate limits
{:ok, activities} = ExOura.multiple_daily_activity(~D[2024-01-01], ~D[2024-01-31])
```

#### Rate Limiting Features

- **Automatic Rate Limit Detection**: Parses `X-RateLimit-*` headers from API responses
- **Proactive Throttling**: Prevents hitting rate limits before they occur
- **Smart Delays**: Adds small delays when approaching rate limits

#### Retry Logic Features  

- **Exponential Backoff**: Automatically increases delay between retry attempts
- **Smart Error Detection**: Only retries on appropriate errors (5xx, network issues, rate limits)
- **Jitter**: Adds randomness to prevent thundering herd problems
- **Configurable**: Customize max attempts, delays, and backoff factors

#### Advanced Usage

```elixir
# Custom retry configuration
alias ExOura.Retry

request_fn = fn ->
  ExOura.multiple_daily_activity(~D[2024-01-01], ~D[2024-01-31]) 
end

{:ok, result} = Retry.with_retry(request_fn, [
  max_attempts: 5,
  base_delay: 2000,    # Start with 2 second delay
  max_delay: 30_000,   # Cap at 30 seconds
  backoff_factor: 2.5  # More aggressive backoff
])

# Monitor rate limit status
status = ExOura.RateLimiter.get_status()
IO.puts "Daily remaining: #{status.remaining}"
IO.puts "Per-minute remaining: #{status.per_minute_remaining}"
```

## Oura OpenAPI issues

 A few issues in the Oura spec that I came across during the implementation:

  - no title for tag/timestamp
  - daily cardiovascular age has no ID -> no way to query a single document 


## License

This project is licensed under the MIT License.