defmodule ExOura.HeartRate do
  @moduledoc """
  Documentation for Oura API - Heart Rate
  """

  alias ExOura.Client

  @type start_datetime :: Date.t() | DateTime.t() | NaiveDateTime.t()
  @type end_datetime :: Date.t() | DateTime.t() | NaiveDateTime.t()
  @type next_token :: String.t() | nil
  @type opts :: Keyword.t()

  @doc """
  Multiple Heart Rate
  """
  @spec multiple_heart_rate(start_datetime(), end_datetime(), next_token(), opts()) ::
          {:ok, Client.TimeSeriesResponsePublicHeartRateRow.t()} | {:error, term()}
  def multiple_heart_rate(start_datetime, end_datetime, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.HeartRateRoutes,
      :multiple_heartrate_documents_v2_usercollection_heartrate_get,
      [],
      Client.datetime_range_args(start_datetime, end_datetime, next_token) ++ opts
    )
  end
end
