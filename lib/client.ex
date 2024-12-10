defmodule ExOura.Client do
  @moduledoc """
  Default Oura client
  """
  use GenServer

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

  defp handle_response({:ok, %Req.Response{status: status, body: body}}, operation) do
    case operation.response |> Enum.into(%{}) |> Map.get(status, nil) do
      {response_module, _t} when status == 200 ->
        {:ok, struct(response_module, body)}

      {response_module, _t} ->
        {:error, struct(response_module, body)}

      :null ->
        {:error, body}
    end
  end

  defp handle_response({:error, _exception} = error, _operation), do: error

  defp req_opts(operation, %{bearer_token: bearer_token} = _state) do
    [
      base_url: @base_url,
      params: Map.get(operation, :query, []),
      auth: {:bearer, bearer_token},
      decode_json: [keys: :atoms]
    ]
  end

  defp apply(mod, fun, [] = _args, opts), do: apply(mod, fun, [opts])
  defp apply(mod, fun, args, opts), do: apply(mod, fun, [args, opts])

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
end
