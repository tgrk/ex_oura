defmodule ExOura.RingBatteryLevel do
  @moduledoc """
  API functions for retrieving Oura ring battery level time-series data.
  """

  alias ExOura.Client

  @type start_datetime :: DateTime.t() | NaiveDateTime.t()
  @type end_datetime :: DateTime.t() | NaiveDateTime.t()
  @type next_token :: String.t() | nil
  @type opts :: Keyword.t()

  @doc """
  Retrieves ring battery level rows for a time range.
  """
  @spec multiple_ring_battery_level(start_datetime(), end_datetime(), next_token(), opts()) ::
          {:ok, Client.TimeSeriesResponsePublicRingBatteryLevelRow.t()} | {:error, term()}
  def multiple_ring_battery_level(start_datetime, end_datetime, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.RingBatteryLevelRoutes,
      :multiple_ring_battery_level_documents_v2_usercollection_ring_battery_level_get,
      [],
      Client.datetime_range_args(start_datetime, end_datetime, next_token) ++ opts
    )
  end
end
