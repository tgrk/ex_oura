defmodule ExOura.Client do
  @moduledoc """
  Default Oura client
  """
  use GenServer

  alias ExOura.TypeDecoder

  @base_url "https://api.ouraring.com"

  @timeout Application.compile_env(:ex_oura, :timeout, 5_000)

  # Client API

  @doc """
  Calls Oura Client modules
  """
  def call_api(mod, fun, args, opts) do
    if client_ready?(opts) do
      apply(mod, fun, args, opts)
    else
      {:error, :client_not_ready}
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
  def start_link(auth_token) do
    GenServer.start_link(__MODULE__, auth_token, name: __MODULE__)
  end

  @doc """
  HTTP request for generated OpenApi client
  """
  def request(operation) do
    GenServer.call(__MODULE__, {:request, operation}, @timeout)
  end

  # Server Callbacks

  @impl true
  def init(auth_token) do
    {:ok, %{bearer_token: auth_token}}
  end

  @impl true
  def handle_call({:request, %{method: :get} = operation}, _from, state) do
    reply =
      operation
      |> Map.get(:url)
      |> Req.get(req_opts(operation, state))
      |> handle_response(operation)

    {:reply, reply, state}
  end

  @impl true
  def handle_call({:request, %{method: :post} = operation}, _from, state) do
    reply =
      operation
      |> Map.get(:url)
      |> Req.post(req_opts(operation, state))
      |> handle_response(operation)

    {:reply, reply, state}
  end

  @impl true
  def handle_call({:request, %{method: :put} = operation}, _from, state) do
    reply =
      operation
      |> Map.get(:url)
      |> Req.put(req_opts(operation, state))
      |> handle_response(operation)

    {:reply, reply, state}
  end

  @impl true
  def handle_call({:request, %{method: :delete} = operation}, _from, state) do
    reply =
      operation
      |> Map.get(:url)
      |> Req.delete(req_opts(operation, state))
      |> handle_response(operation)

    {:reply, reply, state}
  end

  defp handle_response({:ok, %Req.Response{status: status, body: body}}, operation)
       when status in [200, 201] do
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
    [
      base_url: @base_url,
      params: Map.get(operation, :query, []),
      auth: {:bearer, bearer_token},
      decode_json: [keys: :atoms],
      body: Map.get(operation, :body),
      headers: maybe_include_client_credentials(operation)
    ]
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
end
