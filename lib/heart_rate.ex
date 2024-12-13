defmodule ExOura.HeartRate do
  @moduledoc """
  Documentation for Oura API - Heart Rate
  """

  alias ExOura.Client

  @doc """
  Multiple Heart Rate
  """
  def multiple_heart_rate(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.HeartRateRoutes,
      :multiple_heart_rate_documents_v2_usercollection_heartrate_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end
end
