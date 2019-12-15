defmodule OuraCloudAPI.Client do
  @moduledoc """
  Documentation for Elixir client for Oura Ring API.
  """

  alias OuraCloudAPI.PersonalInfo

  @base_uri "https://cloud.ouraring.com"
  @token_uri "https://api.ouraring.com/oauth/token"

  @type client :: OAuth2.Client.t()
  @type error_result :: {:error, term()}

  @spec new(keyword) :: {:ok, client()}
  def new(opts \\ []) do
    client =
      OAuth2.Client.new(
        # default
        strategy: OAuth2.Strategy.AuthCode,
        client_id: System.get_env("OURA_API_CLIENT_ID"),
        client_secret: System.get_env("OURA_API_CLIENT_SECRET"),
        site: Keyword.get(opts, :site, ""),
        redirect_uri: Keyword.get(opts, :redirect_uri, "")
      )

    {:ok, client}
  end

  @spec authorize_url!(client()) :: binary()
  def authorize_url!(client) do
    @base_uri <> OAuth2.Client.authorize_url!(client)
  end

  @spec get_token(client(), binary()) :: {:ok, client()} | error_result()
  def get_token(client, auth_code) do
    OAuth2.Client.get_token(client, code: auth_code)
  end

  @spec get_user_info(client()) :: {:ok, PersonalInfo.t()} | error_result()
  def get_user_info(client) do
    case get(client, "/v1/user_info") do
      {:ok, body} ->
        {:ok, struct(PersonalInfo, body)}

      {:error, _reason} = error ->
        error
    end
  end

  def get_daily_summary(client, type, start_date, end_date)
      when type in [:sleep, :activity, :readiness] do
    get(client, "/v1/#{type}?start=#{format_date(start_date)}&end=#{format_date(end_date)}")
  end

  def get_daily_summary(_client, _type, _start_date, _end_Date) do
    {:error, :unknown_type}
  end

  defp get(client, path) do
    client
    |> OAuth2.Client.get("#{@base_uri}#{path}")
    |> process_results()
  end

  defp process_results({:ok, %OAuth2.Response{body: body}}) do
    {:ok, body}
  end

  defp process_results({:error, %OAuth2.Response{body: reason}}) do
    {:error, reason}
  end

  defp process_results({:error, %OAuth2.Error{reason: reason}}) do
    {:error, reason}
  end

  defp validate_opts(authorize, opts) do
    # TODO: check for client_id and redirect_uri
  end

  defp validate_opts(exchange_access_token, opts) do
    # TODO: check for client_id, client_secret, code
  end

  defp format_date(date) do
    {:ok, formatted_date} = Timex.format(date, "{YYYY}-{MM}-{DD}")
    formatted_date
  end
end
