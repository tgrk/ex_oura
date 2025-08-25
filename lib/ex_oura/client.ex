defmodule ExOura.Client do
  @moduledoc """
  Default Oura client
  """
  use GenServer

  alias ExOura.RateLimiter
  alias ExOura.TypeDecoder

  @base_url "https://api.ouraring.com"

  @timeout Application.compile_env(:ex_oura, :timeout, 5_000)

  @rate_limiting_config Application.compile_env(:ex_oura, :rate_limiting, [])

  # Default retry configuration for Req
  @retry_config Application.compile_env(:ex_oura, :retry, [])
  @default_retry_opts [
    retry: &__MODULE__.should_retry?/2,
    retry_delay: &__MODULE__.retry_delay/1,
    max_retries: Keyword.get(@retry_config, :max_retries, 3)
  ]

  # Client API

  @doc """
  Calls Oura Client modules
  """
  def call_api(mod, fun, args, opts) do
    with true <- client_ready?(opts),
         :ok <- validate_date_range_args(opts) do
      apply(mod, fun, args, opts)
    else
      false ->
        {:error, :client_not_ready}

      {:error, _reason} = error ->
        error
    end
  end

  def date_range_args(start_date, end_date, next_token \\ nil) do
    [
      start_date: start_date,
      end_date: end_date,
      next_token: next_token
    ]
  end

  @doc """
  Starts the GenServer with an initial bearer auth token.
  """
  def start_link(access_token \\ nil) do
    GenServer.start_link(__MODULE__, access_token, name: __MODULE__)
  end

  @doc """
  HTTP request for generated OpenApi client
  """
  def request(operation) do
    GenServer.call(__MODULE__, {:request, operation}, @timeout)
  end

  # Server Callbacks

  @impl true
  def init(access_token) do
    {:ok, %{bearer_token: get_access_token(access_token)}}
  end

  @impl true
  def handle_call({:request, %{method: :get} = operation}, _from, state) do
    reply =
      make_request_with_retry(
        fn ->
          operation
          |> Map.get(:url)
          |> Req.get(req_opts(operation, state))
        end,
        operation
      )

    {:reply, reply, state}
  end

  @impl true
  def handle_call({:request, %{method: :post} = operation}, _from, state) do
    reply =
      make_request_with_retry(
        fn ->
          operation
          |> Map.get(:url)
          |> Req.post(req_opts(operation, state))
        end,
        operation
      )

    {:reply, reply, state}
  end

  @impl true
  def handle_call({:request, %{method: :put} = operation}, _from, state) do
    reply =
      make_request_with_retry(
        fn ->
          operation
          |> Map.get(:url)
          |> Req.put(req_opts(operation, state))
        end,
        operation
      )

    {:reply, reply, state}
  end

  @impl true
  def handle_call({:request, %{method: :delete} = operation}, _from, state) do
    reply =
      make_request_with_retry(
        fn ->
          operation
          |> Map.get(:url)
          |> Req.delete(req_opts(operation, state))
        end,
        operation
      )

    {:reply, reply, state}
  end

  # Private helper for making requests with rate limiting and using Req's built-in retry
  defp make_request_with_retry(request_fn, operation) do
    check_rate_limits_before_request()
    make_request_and_handle_response(request_fn, operation)
  end

  defp check_rate_limits_before_request do
    if enabled?() do
      try do
        case RateLimiter.check_rate_limit() do
          {:ok, delay} when delay > 0 ->
            :timer.sleep(delay)

          {:error, {:rate_limited, retry_after}} ->
            :timer.sleep(retry_after * 1000)

          {:ok, 0} ->
            :ok
        end
      catch
        :exit, _ -> :ok
      end
    else
      :ok
    end
  end

  defp make_request_and_handle_response(request_fn, operation) do
    case request_fn.() do
      {:ok, %Req.Response{headers: headers} = response} ->
        update_rate_limits_from_headers(headers)
        record_request_for_rate_limiting()
        handle_response({:ok, response}, operation)

      error ->
        handle_response(error, operation)
    end
  end

  defp record_request_for_rate_limiting do
    if enabled?() do
      try do
        RateLimiter.record_request()
      catch
        :exit, _ -> :ok
      end
    else
      :ok
    end
  end

  defp update_rate_limits_from_headers(headers) do
    if enabled?() do
      try do
        RateLimiter.update_rate_limit_headers(headers)
      catch
        # Rate limiter not running
        :exit, _ -> :ok
      end
    else
      :ok
    end
  end

  defp handle_response({:ok, %Req.Response{status: status, body: body}}, operation) when status in [200, 201] do
    TypeDecoder.decode_response(status, body, operation)
  end

  defp handle_response({:ok, %Req.Response{status: 204, body: _body}}, _operation) do
    :ok
  end

  defp handle_response({:ok, %Req.Response{status: status, body: body}}, operation) do
    case TypeDecoder.decode_response(status, body, operation) do
      {:ok, error} ->
        {:error, error}

      {:error, :unable_to_decode} ->
        {:error, body}
    end
  end

  defp handle_response({:error, _exception} = error, _operation), do: error

  defp req_opts(operation, %{bearer_token: bearer_token} = _state) do
    base_opts = [
      base_url: @base_url,
      params: Map.get(operation, :query, []),
      auth: {:bearer, bearer_token},
      decode_json: [keys: :atoms],
      body: Map.get(operation, :body),
      headers: maybe_include_client_credentials(operation)
    ]

    # Add retry configuration to base options
    base_opts ++ @default_retry_opts
  end

  @doc false
  def should_retry?({:error, %Req.Response{status: status}}, _) when status in [408, 429] or status >= 500 do
    true
  end

  def should_retry?({:error, %Req.TransportError{}}, _), do: true
  def should_retry?(_, _), do: false

  @doc false
  def retry_delay(attempt) do
    # Exponential backoff: 1s, 2s, 4s, etc., with max of 30s
    base_delay = 1000
    max_delay = 30_000
    delay = base_delay * :math.pow(2, attempt - 1)

    # Add jitter (±10%)
    jitter = delay * 0.1 * (:rand.uniform() - 0.5)

    (delay + jitter)
    |> min(max_delay)
    |> round()
  end

  defp maybe_include_client_credentials(operation) do
    if webhook?(operation) do
      [
        {"x-client-id", System.get_env("OURA_CLIENT_ID")},
        {"x-client-secret", System.get_env("OURA_CLIENT_SECRET")}
      ]
    else
      []
    end
  end

  defp apply(mod, fun, [] = _args, opts), do: apply(mod, fun, [opts])
  defp apply(mod, fun, [_ | _] = args, opts), do: apply(mod, fun, args ++ opts)
  defp apply(mod, fun, args, opts), do: apply(mod, fun, [args] ++ opts)

  defp client_ready?(opts) do
    if Keyword.has_key?(opts, :client) do
      true
    else
      case Process.whereis(ExOura.Client) do
        nil -> false
        client_pid -> Process.alive?(client_pid)
      end
    end
  end

  defp webhook?(operation) do
    case Map.get(operation, :call) do
      {ExOura.Client.WebhookSubscriptionRoutes, _} -> true
      _non_webhook_call -> false
    end
  end

  defp get_access_token(access_token) do
    Application.get_env(:ex_oura, :access_token, access_token)
  end

  defp validate_date_range_args(opts) do
    start_date = Keyword.get(opts, :start_date)
    end_date = Keyword.get(opts, :end_date)

    if start_date != nil && end_date != nil do
      case {valid_date?(start_date), valid_date?(end_date)} do
        {false, _} -> {:error, :invalid_start_date}
        {_, false} -> {:error, :invalid_end_date}
        {true, true} -> start_date_before_end_date?(start_date, end_date)
      end
    else
      :ok
    end
  end

  defp start_date_before_end_date?(start_date, end_date) do
    if Date.before?(end_date, start_date) do
      {:error, :end_date_before_start_date}
    else
      :ok
    end
  end

  defp enabled?, do: Keyword.get(@rate_limiting_config, :enabled, true)

  defp valid_date?(%Date{} = _date), do: true
  defp valid_date?(_date), do: false
end
