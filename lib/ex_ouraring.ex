defmodule ExOuraring do
  @moduledoc """
  Documentation for Elixir client for Oura Ring API.
  """

  @spec new(keyword) :: {:ok, OAuth2.Client.t()}
  defdelegate new(opts), to: ExOuraring.Client

  @spec authorize(OAuth2.Client.t()) :: binary
  defdelegate authorize(client), to: ExOuraring.Client

  defdelegate get_token(client, auth_code), to: ExOuraring.Client

  defdelegate get_user_info(client), to: ExOuraring.Client

  defdelegate get_daily_summary(client, activity, start_date, end_date),
    to: ExOuraring.Client
end
