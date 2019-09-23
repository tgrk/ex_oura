defmodule ExOuraring.Client do
  @moduledoc """
  Documentation for Elixir client for Oura Ring API.
  """
  @base_uri "https://cloud.ouraring.com"

  @spec new(keyword) :: {:ok, OAuth2.Client.t()}
  def new(opts) do
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

  @spec authorize(OAuth2.Client.t()) :: binary
  def authorize(client) do
    OAuth2.Client.authorize_url!(client)
  end

  def get_token(client, auth_code) do
    OAuth2.Client.get_token(client, code: auth_code)
  end

  def get_user_info(client) do
    get(client, "/v1/user_info")
  end

  def get_daily_summary(client, type, start_date, end_date)
      when type in [:sleep, :activity, :readiness] do
    get(client, "/v1/#{type}?start=#{format_date(start_date)}&end=#{format_date(end_date)}")
  end

  defp get(client, path) do
    OAuth2.Client.get(client, "#{@base_uri}#{path}")
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
