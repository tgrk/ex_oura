defmodule ExOura.Client.HeartRateRoutes do
  @moduledoc """
  Provides API endpoint related to heart rate routes
  """

  @default_client ExOura.Client

  @doc """
  Multiple Heart Rate Documents

  ## Options

    * `start_datetime`
    * `end_datetime`
    * `next_token`

  """
  @spec multiple_heart_rate_documents_v2_usercollection_heartrate_get(keyword) ::
          {:ok, ExOura.Client.TimeSeriesResponseHeartRateModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def multiple_heart_rate_documents_v2_usercollection_heartrate_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_datetime, :next_token, :start_datetime])

    client.request(%{
      args: [],
      call:
        {ExOura.Client.HeartRateRoutes,
         :multiple_heart_rate_documents_v2_usercollection_heartrate_get},
      url: "/v2/usercollection/heartrate",
      method: :get,
      query: query,
      response: [
        {200, {ExOura.Client.TimeSeriesResponseHeartRateModel, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {ExOura.Client.HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end
end
