defmodule OuraCloudAPI do
  @moduledoc """
  Documentation for Elixir client for Oura Cloud API.
  """

  @spec new(keyword) :: {:ok, OAuth2.Client.t()}
  defdelegate new(opts \\ []), to: OuraCloudAPI.Client

  @spec authorize_url!(OAuth2.Client.t()) :: binary
  defdelegate authorize_url!(client), to: OuraCloudAPI.Client

  defdelegate get_token(client, auth_code), to: OuraCloudAPI.Client

  defdelegate get_user_info(client), to: OuraCloudAPI.Client

  defdelegate get_daily_summary(client, activity, start_date, end_date),
    to: OuraCloudAPI.Client
end
