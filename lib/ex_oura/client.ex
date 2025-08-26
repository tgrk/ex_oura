defmodule ExOura.Client do
  @moduledoc false

  use GenServer

  alias ExOura.OAuth2
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
  Sets the OAuth2 authentication configuration for the client.
  """
  @spec set_auth_config(OAuth2.oauth2_config()) :: :ok | {:error, term()}
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

  def date_range_args(start_date, end_date, next_token \\ nil)

  def date_range_args(start_date, end_date, nil = _next_token) do
    [
      start_date: start_date,
      end_date: end_date
    ]
  end

  def date_range_args(start_date, end_date, next_token) do
    [
      start_date: start_date,
      end_date: end_date,
      next_token: next_token
    ]
  end

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
    GenServer.call(__MODULE__, {:request, operation}, @timeout)
  end

  # Server Callbacks

  @impl true
  def init(auth_config) do
    {:ok, prepare_state(auth_config)}
  end

  @impl true
  def handle_call({:request, %{method: :get} = operation}, _from, state) do
    {:ok, new_state} = maybe_refresh_token(state)

    reply =
      make_request_with_retry(
        fn ->
          operation
          |> Map.get(:url)
          |> Req.get(req_opts(operation, new_state))
        end,
        operation
      )

    {:reply, reply, new_state}
  end

  @impl true
  def handle_call({:request, %{method: :post} = operation}, _from, state) do
    {:ok, new_state} = maybe_refresh_token(state)

    reply =
      make_request_with_retry(
        fn ->
          operation
          |> Map.get(:url)
          |> Req.post(req_opts(operation, new_state))
        end,
        operation
      )

    {:reply, reply, new_state}
  end

  @impl true
  def handle_call({:request, %{method: :put} = operation}, _from, state) do
    {:ok, new_state} = maybe_refresh_token(state)

    reply =
      make_request_with_retry(
        fn ->
          operation
          |> Map.get(:url)
          |> Req.put(req_opts(operation, new_state))
        end,
        operation
      )

    {:reply, reply, new_state}
  end

  @impl true
  def handle_call({:request, %{method: :delete} = operation}, _from, state) do
    {:ok, new_state} = maybe_refresh_token(state)

    reply =
      make_request_with_retry(
        fn ->
          operation
          |> Map.get(:url)
          |> Req.delete(req_opts(operation, new_state))
        end,
        operation
      )

    {:reply, reply, new_state}
  end

  @impl true
  def handle_call(:get_token_info, _from, state) do
    token_info = %{
      access_token: state.access_token,
      refresh_token: state.refresh_token,
      expires_at: state[:expires_at],
      expires_in: state[:expires_in],
      auth_type: state.auth_type
    }

    {:reply, {:ok, token_info}, state}
  end

  @impl true
  def handle_call({:set_auth_config, auth_config}, _from, _state) do
    {:reply, :ok, prepare_state(auth_config)}
  end

  @impl true
  def handle_call(:refresh_oauth2_token, _from, %{auth_type: :oauth2, refresh_token: refresh_token} = state)
      when is_binary(refresh_token) do
    case OAuth2.refresh_token(refresh_token) do
      {:ok, new_tokens} ->
        updated_refresh_token =
          case new_tokens.refresh_token do
            nil -> refresh_token
            token -> token
          end

        new_state = %{
          state
          | access_token: new_tokens.access_token,
            refresh_token: updated_refresh_token,
            expires_at: new_tokens.expires_at,
            expires_in: new_tokens.expires_in,
            auth_type: :oauth2
        }

        token_info = %{
          access_token: new_tokens.access_token,
          refresh_token: updated_refresh_token,
          expires_at: new_tokens.expires_at,
          expires_in: new_tokens.expires_in,
          auth_type: :oauth2
        }

        {:reply, {:ok, token_info}, new_state}

      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_call(:refresh_oauth2_token, _from, state) do
    {:reply, {:error, :no_refresh_token}, state}
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

  defp req_opts(operation, %{access_token: access_token} = _state) do
    base_opts = [
      base_url: @base_url,
      params: Map.get(operation, :query, []),
      auth: {:bearer, access_token},
      decode_json: [keys: :atoms],
      body: Map.get(operation, :body),
      headers: maybe_include_client_credentials(operation, access_token)
    ]

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

  defp maybe_include_client_credentials(operation, access_token) do
    if webhook?(operation) do
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

  defp maybe_refresh_token(%{auth_type: :oauth2, expires_at: expires_at, refresh_token: refresh_token} = state)
       when is_binary(refresh_token) do
    if expires_at && DateTime.after?(DateTime.utc_now(), expires_at) do
      case OAuth2.refresh_token(refresh_token) do
        {:ok, new_token_info} ->
          updated_state = %{
            state
            | access_token: new_token_info.access_token,
              refresh_token: new_token_info.refresh_token || refresh_token,
              expires_at: new_token_info.expires_at,
              expires_in: new_token_info.expires_in
          }

          {:ok, updated_state}

        {:error, _reason} = error ->
          error
      end
    else
      {:ok, state}
    end
  end

  defp maybe_refresh_token(state) do
    # For bearer tokens or OAuth2 without refresh token, no refresh needed
    {:ok, state}
  end

  defp prepare_state(auth_config) do
    case auth_config do
      # OAuth2 configuration with keyword list (full config)
      auth_list when is_list(auth_list) ->
        access_token = Keyword.get(auth_list, :access_token)
        refresh_token = Keyword.get(auth_list, :refresh_token)
        expires_at = Keyword.get(auth_list, :expires_at)
        expires_in = Keyword.get(auth_list, :expires_in)

        cond do
          # OAuth2 with refresh token
          is_binary(access_token) and is_binary(refresh_token) ->
            %{
              access_token: access_token,
              refresh_token: refresh_token,
              expires_at: expires_at,
              expires_in: expires_in,
              auth_type: :oauth2
            }

          # OAuth2 access token only
          is_binary(access_token) ->
            %{
              access_token: access_token,
              refresh_token: nil,
              expires_at: expires_at,
              expires_in: expires_in,
              auth_type: :oauth2
            }

          true ->
            # Fallback to config
            token = get_access_token(nil)

            %{
              access_token: token,
              refresh_token: nil,
              auth_type: :bearer
            }
        end

      # Simple string token (Personal Access Token or OAuth2 access token)
      access_token when is_binary(access_token) ->
        %{
          access_token: access_token,
          refresh_token: nil,
          auth_type: :bearer
        }

      auth_config when is_map(auth_config) ->
        %{
          access_token: auth_config.access_token,
          expires_at: auth_config.expires_at,
          expires_in: auth_config.expires_in,
          refresh_token: auth_config.refresh_token,
          auth_type: :oauth2
        }

      # No token provided, try to get from config
      _ ->
        token = get_access_token(nil)

        %{
          access_token: token,
          refresh_token: nil,
          auth_type: :bearer
        }
    end
  end
end
