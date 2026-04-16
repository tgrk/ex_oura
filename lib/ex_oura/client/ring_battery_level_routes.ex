defmodule ExOura.Client.RingBatteryLevelRoutes do
  @moduledoc """
  Provides API endpoint related to ring battery level routes
  """

  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.TimeSeriesResponseDict
  alias ExOura.Client.TimeSeriesResponsePublicRingBatteryLevelRow

  @default_client ExOura.Client

  @doc """
  Multiple Ring Battery Level Documents

  ## Options

    * `start_datetime`
    * `end_datetime`
    * `next_token`
    * `latest`
    * `fields`: Comma-separated list of fields to include in the response, in addition to the always returned fields. Defaults to all fields if not provided.

  """
  @spec multiple_ring_battery_level_documents_v2_usercollection_ring_battery_level_get(opts :: keyword) ::
          {:ok,
           TimeSeriesResponseDict.t()
           | TimeSeriesResponsePublicRingBatteryLevelRow.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_ring_battery_level_documents_v2_usercollection_ring_battery_level_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_datetime, :fields, :latest, :next_token, :start_datetime])

    client.request(%{
      args: [],
      call:
        {ExOura.Client.RingBatteryLevelRoutes,
         :multiple_ring_battery_level_documents_v2_usercollection_ring_battery_level_get},
      url: "/v2/usercollection/ring_battery_level",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {TimeSeriesResponseDict, :t},
            {TimeSeriesResponsePublicRingBatteryLevelRow, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end
end
