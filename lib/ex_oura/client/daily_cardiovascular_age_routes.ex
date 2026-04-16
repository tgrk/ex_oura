defmodule ExOura.Client.DailyCardiovascularAgeRoutes do
  @moduledoc """
  Provides API endpoints related to daily cardiovascular age routes
  """

  alias ExOura.Client.DailyCardiovascularAgeRoutes
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponsePublicDailyCardiovascularAge
  alias ExOura.Client.PublicDailyCardiovascularAge

  @default_client ExOura.Client

  @doc """
  Multiple Daily Cardiovascular Age Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`
    * `fields`: Comma-separated list of fields to include in the response, in addition to the always returned fields. Defaults to all fields if not provided.

  """
  @spec multiple_daily_cardiovascular_age_documents_v2_usercollection_daily_cardiovascular_age_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicDailyCardiovascularAge.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_daily_cardiovascular_age_documents_v2_usercollection_daily_cardiovascular_age_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :fields, :next_token, :start_date])

    client.request(%{
      args: [],
      call:
        {DailyCardiovascularAgeRoutes,
         :multiple_daily_cardiovascular_age_documents_v2_usercollection_daily_cardiovascular_age_get},
      url: "/v2/usercollection/daily_cardiovascular_age",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicDailyCardiovascularAge, :t}
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
  Single Daily Cardiovascular Age Document
  """
  @spec single_daily_cardiovascular_age_document_v2_usercollection_daily_cardiovascular_age_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicDailyCardiovascularAge.t()}
          | {:error, HTTPValidationError.t()}
  def single_daily_cardiovascular_age_document_v2_usercollection_daily_cardiovascular_age_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {DailyCardiovascularAgeRoutes,
         :single_daily_cardiovascular_age_document_v2_usercollection_daily_cardiovascular_age_document_id_get},
      url: "/v2/usercollection/daily_cardiovascular_age/#{document_id}",
      method: :get,
      response: [
        {200, {PublicDailyCardiovascularAge, :t}},
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
