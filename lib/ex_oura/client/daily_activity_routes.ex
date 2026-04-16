defmodule ExOura.Client.DailyActivityRoutes do
  @moduledoc """
  Provides API endpoints related to daily activity routes
  """

  alias ExOura.Client.DailyActivityRoutes
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponsePublicDailyActivity
  alias ExOura.Client.PublicDailyActivity

  @default_client ExOura.Client

  @doc """
  Multiple Daily Activity Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`
    * `fields`: Comma-separated list of fields to include in the response, in addition to the always returned fields. Defaults to all fields if not provided.

  """
  @spec multiple_daily_activity_documents_v2_usercollection_daily_activity_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicDailyActivity.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_daily_activity_documents_v2_usercollection_daily_activity_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :fields, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {DailyActivityRoutes, :multiple_daily_activity_documents_v2_usercollection_daily_activity_get},
      url: "/v2/usercollection/daily_activity",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicDailyActivity, :t}
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

  @doc """
  Single Daily Activity Document
  """
  @spec single_daily_activity_document_v2_usercollection_daily_activity_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicDailyActivity.t()}
          | {:error, HTTPValidationError.t()}
  def single_daily_activity_document_v2_usercollection_daily_activity_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {DailyActivityRoutes, :single_daily_activity_document_v2_usercollection_daily_activity_document_id_get},
      url: "/v2/usercollection/daily_activity/#{document_id}",
      method: :get,
      response: [
        {200, {PublicDailyActivity, :t}},
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
