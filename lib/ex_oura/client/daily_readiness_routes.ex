defmodule ExOura.Client.DailyReadinessRoutes do
  @moduledoc """
  Provides API endpoints related to daily readiness routes
  """

  alias ExOura.Client.DailyReadinessRoutes
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponsePublicDailyReadiness
  alias ExOura.Client.PublicDailyReadiness

  @default_client ExOura.Client

  @doc """
  Multiple Daily Readiness Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`
    * `fields`: Comma-separated list of fields to include in the response, in addition to the always returned fields. Defaults to all fields if not provided.

  """
  @spec multiple_daily_readiness_documents_v2_usercollection_daily_readiness_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicDailyReadiness.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_daily_readiness_documents_v2_usercollection_daily_readiness_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :fields, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {DailyReadinessRoutes, :multiple_daily_readiness_documents_v2_usercollection_daily_readiness_get},
      url: "/v2/usercollection/daily_readiness",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicDailyReadiness, :t}
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
  Single Daily Readiness Document
  """
  @spec single_daily_readiness_document_v2_usercollection_daily_readiness_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicDailyReadiness.t()}
          | {:error, HTTPValidationError.t()}
  def single_daily_readiness_document_v2_usercollection_daily_readiness_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {DailyReadinessRoutes, :single_daily_readiness_document_v2_usercollection_daily_readiness_document_id_get},
      url: "/v2/usercollection/daily_readiness/#{document_id}",
      method: :get,
      response: [
        {200, {PublicDailyReadiness, :t}},
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
