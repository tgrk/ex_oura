defmodule ExOura.Client do
  @moduledoc """
  Default HTTP client
  """
  use GenServer

  # Client API

  @doc """
  Starts the GenServer with an initial bearer auth token.
  """
  def start_link(auth_token) do
    GenServer.start_link(__MODULE__, auth_token, name: __MODULE__)
  end

  @doc """
  """
  def request(method, args, opts \\ []) do
    GenServer.call(__MODULE__, {:request, method, args, opts})
  end

  # Server Callbacks

  @impl true
  def init(auth_token) do
    {:ok, %{bearer_token: auth_token}}
  end

  @impl true
  def handle_call({:request, :get, url, args, opts}, _from, state) do
    url
    |> build_uri(args)
    |> Req.get(opts)
    |> handle_response()
  end

  def auth(token) do
    [
      auth: {:bearer, token}
    ]
  end

  defp handle_response({:ok, response} = r) do
    r
  end

  defp handle_response({:error, exception} = e) do
    e
  end

  defp build_uri(url, args) do
    url
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(args))
    |> URI.to_string()
  end
end
