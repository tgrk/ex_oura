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

- **Basic authorization** support (OAuth2 support is on the roadmap)
- Fetch data such as activity, readiness, and sleep metrics 
- Built on the robust Elixir ecosystem 
- Compatible with OpenAPI v1.27

## Installation

Add `ex_oura` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_oura, "~> 1.0.0"}
  ]
end
```

## Usage

Currently, the client support only a basic authorization and you should obtain an access token [here](https://cloud.ouraring.com/docs/authentication).

Using configuration via `config.exs`:
```elixir
config :ex_oura,
  access_token: "<YOUR_PERSONAL_ACCESS_TOKEN>",
  timeout: 10_000,
  rate_limiting: [
    enabled: true,          # Enable/disable rate limiting (default: true)
    daily_limit: 5000,      # Daily request limit (default: 5000)
    per_minute_limit: 300   # Per-minute request limit (default: 300)
  ],
  retry: [
    max_retries: 3          # Maximum retry attempts using Req's built-in retry (default: 3)
  ]
```

Inline configuration:
```elixir
acces_token = "<YOUR_PERSONAL_ACCESS_TOKEN>"
ExOura.Client.start_link(access_token)
```

Once configured, you can fetch data from Oura as follows:

```elixir
# Start the client
{:ok, client} = ExOura.Client.start_link("<YOUR_PERSONAL_ACCESS_TOKEN>")

# Fetch single page of daily activity data
{:ok, activity_response} = ExOura.multiple_daily_activity(~D[2025-01-01], ~D[2025-01-31])
IO.inspect(activity_response.data)

# Fetch single document by ID
{:ok, single_activity} = ExOura.single_daily_activity("activity_id")
IO.inspect(single_activity)
```

### Pagination Support

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