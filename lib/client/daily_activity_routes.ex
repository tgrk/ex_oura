defmodule ExOura.Client.DailyActivityRoutes do
  @moduledoc """
  Provides API endpoints related to daily activity routes
  """

  alias ExOura.Client.DailyActivityRoutes
  alias ExOura.Client.HTTPValidationError

  @default_client ExOura.Client

  @doc """
  Multiple Daily Activity Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  def multiple_daily_activity_documents_v2_usercollection_daily_activity_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {DailyActivityRoutes, :multiple_daily_activity_documents_v2_usercollection_daily_activity_get},
      url: "/v2/usercollection/daily_activity",
      method: :get,
      query: query,
      response: [
        {200, {ExOura.Client.MultiDocumentResponseDailyActivityModel, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Single Daily Activity Document
  """
  def single_daily_activity_document_v2_usercollection_daily_activity_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {DailyActivityRoutes, :single_daily_activity_document_v2_usercollection_daily_activity_document_id_get},
      url: "/v2/usercollection/daily_activity/#{document_id}",
      method: :get,
      response: [
        {200, {ExOura.Client.DailyActivityModel, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end
end
