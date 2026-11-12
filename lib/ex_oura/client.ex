defmodule ExOura.Client do
  @moduledoc false

  use GenServer

  alias ExOura.OAuth2
  alias ExOura.RateLimiter
  alias ExOura.TypeDecoder

  @base_url "https://api.ouraring.com"

  @timeout Application.compile_env(:ex_oura, :timeout, 5_000)

  # Req's default `retry: :safe_transient` retries GET/HEAD on 408/429/5xx and
  # transient network errors, honoring Retry-After; only the attempt count is ours.
  @max_retries :ex_oura |> Application.compile_env(:retry, []) |> Keyword.get(:max_retries, 3)

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
  HTTP request for generated OpenApi client.

  Only the (refreshed) access token comes from the GenServer; the HTTP call and
  decoding run in the caller's process, so requests run concurrently and a slow
  or failing request cannot block or crash the shared client.

  A per-call `access_token:` option skips the shared client token entirely,
  so multi-user apps never send one user's request with another user's token.
  """
  def request(operation) do
    with {:ok, access_token} <- fetch_access_token(operation) do
      make_request(operation, access_token)
    end
  end

  defp fetch_access_token(operation) do
    case operation |> Map.get(:opts, []) |> Keyword.get(:access_token) do
      token when is_binary(token) -> {:ok, token}
      _ -> GenServer.call(__MODULE__, :access_token, @timeout)
    end
  end

  # Server Callbacks

  @impl true
  def init(auth_config) do
    {:ok, prepare_state(auth_config)}
  end

  @impl true
  def handle_call(:access_token, _from, state) do
    case maybe_refresh_token(state) do
      {:ok, new_state} ->
        {:reply, {:ok, new_state.access_token}, new_state}

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

  # RateLimiter no-ops when disabled; retries are handled by Req (see @max_retries)
  defp make_request(%{method: method, url: url} = operation, access_token) do
    with :ok <- check_rate_limit() do
      # method is one of :get | :post | :put | :delete, i.e. Req.get/2 etc.
      result = apply(Req, method, [url, req_opts(operation, access_token)])

      # Casts: safe even when the rate limiter is not running
      with {:ok, %Req.Response{headers: headers}} <- result do
        RateLimiter.update_rate_limit_headers(headers)
        RateLimiter.record_request()
      end

      handle_response(result, operation)
    end
  end

  # A known exhausted limit can last up to a day, so return it instead of sleeping.
  defp check_rate_limit do
    case RateLimiter.check_rate_limit() do
      {:ok, delay} when delay > 0 -> :timer.sleep(delay)
      {:ok, 0} -> :ok
      {:error, {:rate_limited, _retry_after}} = error -> error
    end
  catch
    # Rate limiter not running
    :exit, _ -> :ok
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

  defp req_opts(operation, access_token) do
    [
      base_url: @base_url,
      params: Map.get(operation, :query, []),
      auth: {:bearer, access_token},
      compressed: true,
      decoders: [json: &Jason.decode(&1, keys: :atoms)],
      body: Map.get(operation, :body),
      headers: client_credential_headers(operation),
      max_retries: @max_retries,
      # Per-call `timeout:` option documented on the public wrappers, else the configured one
      receive_timeout: operation |> Map.get(:opts, []) |> Keyword.get(:timeout, @timeout)
    ]
  end

  # The bearer token comes from `auth:`; webhook routes also need the app's client credentials.
  defp client_credential_headers(%{call: {ExOura.Client.WebhookSubscriptionRoutes, _}}) do
    [
      {"x-client-id", OAuth2.config_value(:client_id)},
      {"x-client-secret", OAuth2.config_value(:client_secret)}
    ]
  end

  defp client_credential_headers(_operation), do: []

  defp apply(mod, fun, [] = _args, opts), do: apply(mod, fun, [opts])
  defp apply(mod, fun, [_ | _] = args, opts), do: apply(mod, fun, args ++ opts)
  defp apply(mod, fun, args, opts), do: apply(mod, fun, [args] ++ opts)

  defp ensure_client_ready(opts) do
    pid = Process.whereis(__MODULE__)

    if Keyword.has_key?(opts, :client) or is_binary(opts[:access_token]) or (is_pid(pid) and Process.alive?(pid)) do
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
