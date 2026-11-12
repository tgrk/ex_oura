defmodule ExOura.RateLimiter do
  @moduledoc """
  Handles rate limiting for Oura API requests.

  The Oura API has the following rate limits:
  - Daily: 5000 requests per day
  - Per-minute: 300 requests per minute

  Limits are learned from Oura's `x-ratelimit-*` response headers when present.
  When a known limit is used up and its reset time is in the future, the client
  returns `{:error, {:rate_limited, seconds}}` instead of sending the request.
  Without those headers the limiter starts from the configured limits and only
  adds a short throttle between rapid requests when few requests remain.
  """

  use GenServer

  @type rate_limit_state :: %{
          remaining: non_neg_integer(),
          reset_time: integer() | nil,
          per_minute_remaining: non_neg_integer(),
          per_minute_reset: integer() | nil,
          last_request_time: integer()
        }

  @type check_result :: {:ok, non_neg_integer()} | {:error, {:rate_limited, integer()}}

  # Default rate limits based on Oura API documentation
  @rate_limiting_config Application.compile_env(:ex_oura, :rate_limiting, [])

  ## Client API

  @doc """
  Starts the rate limiter GenServer.

  ## Options

    * `:daily_limit` - Daily request limit (default: 5000)
    * `:per_minute_limit` - Per-minute request limit (default: 300)
    * `:name` - GenServer name (default: __MODULE__)
  """
  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    {name, opts} = Keyword.pop(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @doc """
  Checks if rate limiting is enabled in the configuration.
  """
  @spec enabled?() :: boolean()
  def enabled?, do: Keyword.get(@rate_limiting_config, :enabled, true)

  @doc """
  Checks if a request can be made without exceeding rate limits.
  Returns {:ok, 0} immediately if rate limiting is disabled.

  ## Returns

    * `{:ok, delay}` - Request can be made, with optional delay in milliseconds
    * `{:error, {:rate_limited, retry_after}}` - Request should be delayed, retry_after in seconds
  """
  @spec check_rate_limit() :: check_result()
  def check_rate_limit do
    if enabled?() do
      GenServer.call(__MODULE__, :check_rate_limit)
    else
      {:ok, 0}
    end
  end

  @doc """
  Updates rate limit information from API response headers.
  Does nothing if rate limiting is disabled.

  Expected headers:
  - "x-ratelimit-limit" - Daily limit
  - "x-ratelimit-remaining" - Daily remaining
  - "x-ratelimit-reset" - Daily reset time (Unix timestamp)
  - "x-ratelimit-limit-minute" - Per-minute limit
  - "x-ratelimit-remaining-minute" - Per-minute remaining
  - "x-ratelimit-reset-minute" - Per-minute reset time (Unix timestamp)
  """
  @spec update_rate_limit_headers(map() | list()) :: :ok
  def update_rate_limit_headers(headers) when is_list(headers) do
    if enabled?() do
      headers_map = Map.new(headers, fn {k, v} -> {String.downcase(k), v} end)
      update_rate_limit_headers(headers_map)
    else
      :ok
    end
  end

  def update_rate_limit_headers(headers) when is_map(headers) do
    if enabled?() do
      GenServer.cast(__MODULE__, {:update_headers, headers})
    else
      :ok
    end
  end

  @doc """
  Records the time of the last request (used for throttling rapid requests).
  Remaining counts come only from response headers.
  Does nothing if rate limiting is disabled.
  """
  @spec record_request() :: :ok
  def record_request do
    if enabled?() do
      GenServer.cast(__MODULE__, :record_request)
    else
      :ok
    end
  end

  @doc """
  Gets current rate limit status for debugging/monitoring.
  Returns nil if rate limiting is disabled.
  """
  @spec get_status() :: rate_limit_state() | nil
  def get_status do
    if enabled?() do
      GenServer.call(__MODULE__, :get_status)
    end
  end

  ## GenServer Callbacks

  @impl true
  def init(opts) do
    daily_limit = Keyword.get(opts, :daily_limit, default_daily_limit())
    per_minute_limit = Keyword.get(opts, :per_minute_limit, default_per_minute_limit())

    state = %{
      remaining: daily_limit,
      reset_time: nil,
      per_minute_remaining: per_minute_limit,
      per_minute_reset: nil,
      last_request_time: System.system_time(:second)
    }

    {:ok, state}
  end

  @impl true
  def handle_call(:check_rate_limit, _from, state) do
    now = System.system_time(:second)

    case can_make_request?(state, now) do
      {:ok, delay} ->
        {:reply, {:ok, delay}, state}

      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_call(:get_status, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:update_headers, headers}, state) do
    new_state = parse_rate_limit_headers(headers, state)
    {:noreply, new_state}
  end

  @impl true
  def handle_cast(:record_request, state) do
    # No local decrement: without a reset it would throttle forever after the limit.
    {:noreply, %{state | last_request_time: System.system_time(:second)}}
  end

  ## Private Functions

  defp can_make_request?(state, now) do
    cond do
      # Check daily limit
      (state.remaining <= 0 and state.reset_time) && state.reset_time > now ->
        {:error, {:rate_limited, state.reset_time - now}}

      # Check per-minute limit
      (state.per_minute_remaining <= 0 and state.per_minute_reset) && state.per_minute_reset > now ->
        {:error, {:rate_limited, state.per_minute_reset - now}}

      # Apply basic throttling to avoid bursts
      throttle_delay?(state, now) ->
        {:ok, calculate_throttle_delay(state, now)}

      true ->
        {:ok, 0}
    end
  end

  defp throttle_delay?(state, now) do
    # Apply throttling if we're making requests too quickly
    # Limit to 1 request per 200ms to avoid overwhelming the API
    time_since_last = now - state.last_request_time
    time_since_last < 1 and state.per_minute_remaining < 10
  end

  defp calculate_throttle_delay(state, now) do
    time_since_last = (now - state.last_request_time) * 1000
    max(0, 200 - trunc(time_since_last))
  end

  defp parse_rate_limit_headers(headers, state) do
    {remaining, reset_time} =
      merge_window(
        parse_header_int(headers, "x-ratelimit-remaining"),
        parse_header_int(headers, "x-ratelimit-reset"),
        state.remaining,
        state.reset_time
      )

    {per_minute_remaining, per_minute_reset} =
      merge_window(
        parse_header_int(headers, "x-ratelimit-remaining-minute"),
        parse_header_int(headers, "x-ratelimit-reset-minute"),
        state.per_minute_remaining,
        state.per_minute_reset
      )

    %{
      state
      | remaining: remaining,
        reset_time: reset_time,
        per_minute_remaining: per_minute_remaining,
        per_minute_reset: per_minute_reset
    }
  end

  # Concurrent responses can arrive out of order, so within one reset window keep the lowest count.
  defp merge_window(nil, _new_reset, remaining, reset), do: {remaining, reset}
  # With no known window there is nothing to protect, so the newest count wins (no stuck throttle).
  defp merge_window(new, new_reset, remaining, reset) when not is_nil(reset) and new_reset in [nil, reset],
    do: {min(new, remaining), reset}

  defp merge_window(new, new_reset, _remaining, _reset), do: {new, new_reset}

  # Req gives header values as lists: %{"x-ratelimit-remaining" => ["5"]}
  defp parse_header_int(headers, key), do: headers |> Map.get(key) |> to_int()

  defp to_int([value | _]), do: to_int(value)
  defp to_int(value) when is_integer(value), do: value

  defp to_int(value) when is_binary(value) do
    case Integer.parse(value) do
      {int, ""} -> int
      _ -> nil
    end
  end

  defp to_int(_value), do: nil

  defp default_daily_limit, do: Keyword.get(@rate_limiting_config, :daily_limit, 5000)
  defp default_per_minute_limit, do: Keyword.get(@rate_limiting_config, :per_minute_limit, 300)
end
