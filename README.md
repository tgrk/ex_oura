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
  access_token: "<YOUR_PERSONAL_ACCESS_TOKEN>"
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

## Oura OpenAPI issues

 A few issues in the Oura spec that I came across during the implementation:

  - no title for tag/timestamp
  - daily cardiovascular age has no ID -> no way to query a single document 


## License

This project is licensed under the MIT License.