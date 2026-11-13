defmodule ExOura.Client do
  @moduledoc false

  use GenServer

  alias ExOura.OAuth2
  alias ExOura.RateLimiter
  alias ExOura.TypeDecoder

  @base_url "https://api.ouraring.com"

  @timeout Application.compile_env(:ex_oura, :timeout, 5_000)

  # Default retry configuration for Req
  @retry_config Application.compile_env(:ex_oura, :retry, [])
  @max_retries Keyword.get(@retry_config, :max_retries, 3)
  @default_retry_opts [
    retry: &__MODULE__.should_retry?/2,
    retry_delay: &__MODULE__.retry_delay/1,
    max_retries: @max_retries
  ]

  # Each attempt is bounded by connect + receive timeouts (both @timeout) plus at most 200ms of
  # rate limiter throttling, and retry_delay/1 adds at most 5% jitter. Waiting for the whole
  # budget keeps callers from exiting mid-retry. Exhausted limits fail fast instead of waiting.
  @call_timeout (2 * @timeout + 200) * (@max_retries + 1) +
                  Enum.sum(for n <- 0..(@max_retries - 1)//1, do: min(round(1000 * 2 ** n * 1.05), 30_000))

  defmodule RateLimited do
    @moduledoc false
    defexception [:retry_after]

    @impl true
    def message(%{retry_after: retry_after}), do: "rate limited, retry after #{retry_after}s"
  end

  @doc false
  def call_timeout, do: @call_timeout

  # Client API

  @doc """
  Sets the OAuth2 authentication configuration for the client.
  """
  @spec set_auth_config(OAuth2.oauth2_config() | OAuth2.token_response() | String.t()) :: :ok | {:error, term()}
  def set_auth_config(auth_config) do
    GenServer.call(__MODULE__, {:set_auth_config, auth_config}, @timeout)
  end

  @doc """
  Gets current token information from the client.
  """
  @spec get_token_info() :: {:ok, map()} | {:error, term()}
  def get_token_info do
    GenServer.call(__MODULE__, :get_token_info, @timeout)
  end

  @doc """
  Refreshes the OAuth2 token if a refresh token is available.
  """
  @spec refresh_oauth2_token() :: {:ok, map()} | {:error, term()}
  def refresh_oauth2_token do
    GenServer.call(__MODULE__, :refresh_oauth2_token, @timeout)
  end

  @doc """
  Calls Oura Client modules
  """
  def call_api(mod, fun, args, opts) do
    with :ok <- validate_date_range_args(opts),
         :ok <- validate_datetime_range_args(opts),
         :ok <- ensure_client_ready(opts) do
      apply(mod, fun, args, opts)
    end
  end

  def date_range_args(start_date, end_date, next_token \\ nil) do
    maybe_put_next_token([start_date: start_date, end_date: end_date], next_token)
  end

  def datetime_range_args(start_datetime, end_datetime, next_token \\ nil) do
    maybe_put_next_token([start_datetime: start_datetime, end_datetime: end_datetime], next_token)
  end

  defp maybe_put_next_token(args, nil), do: args
  defp maybe_put_next_token(args, next_token), do: args ++ [next_token: next_token]

  @doc """
  Starts the GenServer with authentication credentials.

  Supports both Personal Access Tokens (deprecated) and OAuth2 tokens (recommended).

  ## Personal Access Token (Deprecated)

      {:ok, client} = ExOura.Client.start_link("your_personal_access_token")

  ## OAuth2 Access Token Only

      {:ok, client} = ExOura.Client.start_link("oauth2_access_token")

  ## OAuth2 with Refresh Token

      {:ok, client} = ExOura.Client.start_link([
        access_token: "oauth2_access_token",
        refresh_token: "oauth2_refresh_token"
      ])

  """
  def start_link(auth_config \\ nil) do
    GenServer.start_link(__MODULE__, auth_config, name: __MODULE__)
  end

  @doc """
  HTTP request for generated OpenApi client
  """
  def request(operation) do
    GenServer.call(__MODULE__, {:request, operation}, @call_timeout)
  end

  # Server Callbacks

  @impl true
  def init(auth_config) do
    {:ok, prepare_state(auth_config)}
  end

  @impl true
  def handle_call({:request, operation}, _from, state) do
    case maybe_refresh_token(state) do
      {:ok, new_state} ->
        {:reply, make_request(operation, new_state), new_state}

      {:error, _reason} = error ->
        {:reply, error, state}
    end
  end

  @impl true
  def handle_call(:get_token_info, _from, state) do
    {:reply, {:ok, state}, state}
  end

  @impl true
  def handle_call({:set_auth_config, auth_config}, _from, _state) do
    {:reply, :ok, prepare_state(auth_config)}
  end

  @impl true
  def handle_call(:refresh_oauth2_token, _from, %{auth_type: :oauth2, refresh_token: refresh_token} = state)
      when is_binary(refresh_token) do
    case refresh_state(state) do
      {:ok, new_state} -> {:reply, {:ok, new_state}, new_state}
      {:error, _reason} = error -> {:reply, error, state}
    end
  end

  @impl true
  def handle_call(:refresh_oauth2_token, _from, state) do
    {:reply, {:error, :no_refresh_token}, state}
  end

  # RateLimiter no-ops when disabled; retries are handled by Req via @default_retry_opts
  defp make_request(%{method: method, url: url} = operation, state) do
    # method is one of :get | :post | :put | :delete, i.e. Req.get/2 etc.
    result = apply(Req, method, [url, req_opts(operation, state)])
    handle_response(result, operation)
  end

  # Req re-runs request and response steps on every retry, so each attempt is throttled and counted.
  @doc false
  def attach_rate_limiting(request) do
    request
    |> Req.Request.append_request_steps(ex_oura_rate_limit: &throttle_and_record/1)
    |> Req.Request.prepend_response_steps(ex_oura_rate_limit_headers: &track_rate_limit_headers/1)
  end

  defp throttle_and_record(request) do
    case check_rate_limit() do
      # Fail fast: waiting for the reset would block every caller of this named client
      {:error, {:rate_limited, retry_after}} ->
        Req.Request.halt(request, %RateLimited{retry_after: retry_after})

      {:ok, delay} ->
        :timer.sleep(delay)
        # Cast: safe even when the rate limiter is not running
        RateLimiter.record_request()
        request
    end
  end

  defp check_rate_limit do
    RateLimiter.check_rate_limit()
  catch
    # Rate limiter not running
    :exit, _ -> {:ok, 0}
  end

  defp track_rate_limit_headers({request, %Req.Response{headers: headers} = response}) do
    RateLimiter.update_rate_limit_headers(headers)
    {request, response}
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

  defp handle_response({:error, %RateLimited{retry_after: retry_after}}, _operation),
    do: {:error, {:rate_limited, retry_after}}

  defp handle_response({:error, _exception} = error, _operation), do: error

  defp req_opts(operation, %{access_token: access_token} = _state) do
    base_opts = [
      base_url: @base_url,
      params: Map.get(operation, :query, []),
      auth: {:bearer, access_token},
      compressed: true,
      decoders: [json: &Jason.decode(&1, keys: :atoms)],
      body: Map.get(operation, :body),
      headers: maybe_include_client_credentials(operation, access_token),
      connect_options: [timeout: @timeout],
      receive_timeout: @timeout,
      plugins: [&__MODULE__.attach_rate_limiting/1]
    ]

    base_opts ++ @default_retry_opts
  end

  @doc false
  # Req calls this as fun.(request, response_or_exception)
  def should_retry?(_request, %Req.Response{status: status}) when status in [408, 429] or status >= 500 do
    true
  end

  def should_retry?(_request, %Req.TransportError{}), do: true
  def should_retry?(_request, _response_or_exception), do: false

  @doc false
  # Req passes the retry count starting at 0
  def retry_delay(retry_count) do
    # Exponential backoff: 1s, 2s, 4s, etc., with max of 30s
    base_delay = 1000
    max_delay = 30_000
    delay = base_delay * :math.pow(2, retry_count)

    # Add jitter (±5%)
    jitter = delay * 0.1 * (:rand.uniform() - 0.5)

    (delay + jitter)
    |> min(max_delay)
    |> round()
  end

  defp maybe_include_client_credentials(operation, access_token) do
    if match?({ExOura.Client.WebhookSubscriptionRoutes, _}, Map.get(operation, :call)) do
      [
        {"x-client-id", System.get_env("OURA_CLIENT_ID")},
        {"x-client-secret", System.get_env("OURA_CLIENT_SECRET")}
      ]
    else
      [
        {"Authorization", "Bearer #{access_token}"}
      ]
    end
  end

  defp apply(mod, fun, [] = _args, opts), do: apply(mod, fun, [opts])
  defp apply(mod, fun, [_ | _] = args, opts), do: apply(mod, fun, args ++ opts)
  defp apply(mod, fun, args, opts), do: apply(mod, fun, [args] ++ opts)

  defp ensure_client_ready(opts) do
    pid = Process.whereis(__MODULE__)

    if Keyword.has_key?(opts, :client) or (is_pid(pid) and Process.alive?(pid)) do
      :ok
    else
      {:error, :client_not_ready}
    end
  end

  defp validate_date_range_args(opts) do
    start_date = Keyword.get(opts, :start_date)
    end_date = Keyword.get(opts, :end_date)

    if start_date != nil && end_date != nil do
      case {valid_date?(start_date), valid_date?(end_date)} do
        {false, _} -> {:error, :invalid_start_date}
        {_, false} -> {:error, :invalid_end_date}
        {true, true} -> validate_date_order(start_date, end_date)
      end
    else
      :ok
    end
  end

  defp validate_datetime_range_args(opts) do
    start_datetime = Keyword.get(opts, :start_datetime)
    end_datetime = Keyword.get(opts, :end_datetime)

    if start_datetime != nil && end_datetime != nil do
      case {valid_datetime?(start_datetime), valid_datetime?(end_datetime)} do
        {false, _} -> {:error, :invalid_start_datetime}
        {_, false} -> {:error, :invalid_end_datetime}
        {true, true} -> validate_datetime_order(start_datetime, end_datetime)
      end
    else
      :ok
    end
  end

  defp validate_date_order(start_date, end_date) do
    if Date.before?(end_date, start_date) do
      {:error, :end_date_before_start_date}
    else
      :ok
    end
  end

  defp validate_datetime_order(start_datetime, end_datetime) do
    if datetime_compare_value(end_datetime) < datetime_compare_value(start_datetime) do
      {:error, :end_datetime_before_start_datetime}
    else
      :ok
    end
  end

  defp valid_date?(%Date{} = _date), do: true
  defp valid_date?(_date), do: false
  defp valid_datetime?(%DateTime{} = _datetime), do: true
  defp valid_datetime?(%NaiveDateTime{} = _datetime), do: true
  defp valid_datetime?(_datetime), do: false

  defp datetime_compare_value(%DateTime{} = datetime), do: DateTime.to_unix(datetime, :microsecond)

  defp datetime_compare_value(%NaiveDateTime{} = datetime) do
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.to_unix(:microsecond)
  end

  defp maybe_refresh_token(%{auth_type: :oauth2, expires_at: expires_at, refresh_token: refresh_token} = state)
       when is_binary(refresh_token) do
    if expires_at && DateTime.after?(DateTime.utc_now(), expires_at) do
      refresh_state(state)
    else
      {:ok, state}
    end
  end

  # For bearer tokens or OAuth2 without refresh token, no refresh needed
  defp maybe_refresh_token(state), do: {:ok, state}

  defp refresh_state(%{refresh_token: refresh_token} = state) do
    with {:ok, tokens} <- OAuth2.refresh_token(refresh_token) do
      {:ok,
       %{
         state
         | access_token: tokens.access_token,
           refresh_token: tokens.refresh_token || refresh_token,
           expires_at: tokens.expires_at,
           expires_in: tokens.expires_in
       }}
    end
  end

  # OAuth2 configuration as keyword list
  defp prepare_state(auth_config) when is_list(auth_config) do
    refresh_token = Keyword.get(auth_config, :refresh_token)

    case Keyword.get(auth_config, :access_token) do
      access_token when is_binary(access_token) ->
        %{
          access_token: access_token,
          refresh_token: if(is_binary(refresh_token), do: refresh_token),
          expires_at: Keyword.get(auth_config, :expires_at),
          expires_in: Keyword.get(auth_config, :expires_in),
          auth_type: :oauth2
        }

      _ ->
        prepare_state(nil)
    end
  end

  # Simple string token (Personal Access Token or OAuth2 access token)
  defp prepare_state(auth_config) when is_binary(auth_config) do
    %{access_token: auth_config, refresh_token: nil, expires_at: nil, expires_in: nil, auth_type: :bearer}
  end

  defp prepare_state(auth_config) when is_map(auth_config) do
    %{
      access_token: auth_config.access_token,
      expires_at: auth_config.expires_at,
      expires_in: auth_config.expires_in,
      refresh_token: auth_config.refresh_token,
      auth_type: :oauth2
    }
  end

  # No usable token provided, fall back to config
  defp prepare_state(_auth_config) do
    %{
      access_token: Application.get_env(:ex_oura, :access_token),
      refresh_token: nil,
      expires_at: nil,
      expires_in: nil,
      auth_type: :bearer
    }
  end
end
