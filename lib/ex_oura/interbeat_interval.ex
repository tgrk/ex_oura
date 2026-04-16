defmodule ExOura.InterbeatInterval do
  @moduledoc """
  API functions for retrieving Oura interbeat interval time-series data.
  """

  alias ExOura.Client

  @type start_datetime :: DateTime.t() | NaiveDateTime.t()
  @type end_datetime :: DateTime.t() | NaiveDateTime.t()
  @type next_token :: String.t() | nil
  @type opts :: Keyword.t()

  @doc """
  Retrieves interbeat interval rows for a time range.
  """
  @spec multiple_interbeat_interval(start_datetime(), end_datetime(), next_token(), opts()) ::
          {:ok, Client.TimeSeriesResponsePublicInterbeatIntervalRow.t()} | {:error, term()}
  def multiple_interbeat_interval(start_datetime, end_datetime, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.InterbeatIntervalRoutes,
      :multiple_interbeat_interval_documents_v2_usercollection_interbeat_interval_get,
      [],
      Client.datetime_range_args(start_datetime, end_datetime, next_token) ++ opts
    )
  end
end
