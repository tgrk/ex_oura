defmodule ExOura.Client.InterbeatIntervalRoutes do
  @moduledoc """
  Provides API endpoint related to interbeat interval routes
  """

  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.TimeSeriesResponseDict
  alias ExOura.Client.TimeSeriesResponsePublicInterbeatIntervalRow

  @default_client ExOura.Client

  @doc """
  Multiple Interbeat Interval Documents

  ## Options

    * `start_datetime`
    * `end_datetime`
    * `next_token`
    * `latest`
    * `fields`: Comma-separated list of fields to include in the response, in addition to the always returned fields. Defaults to all fields if not provided.

  """
  @spec multiple_interbeat_interval_documents_v2_usercollection_interbeat_interval_get(opts :: keyword) ::
          {:ok,
           TimeSeriesResponseDict.t()
           | TimeSeriesResponsePublicInterbeatIntervalRow.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_interbeat_interval_documents_v2_usercollection_interbeat_interval_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_datetime, :fields, :latest, :next_token, :start_datetime])

    client.request(%{
      args: [],
      call:
        {ExOura.Client.InterbeatIntervalRoutes,
         :multiple_interbeat_interval_documents_v2_usercollection_interbeat_interval_get},
      url: "/v2/usercollection/interbeat_interval",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {TimeSeriesResponseDict, :t},
            {TimeSeriesResponsePublicInterbeatIntervalRow, :t}
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
