defmodule ExOura.Client.SleepTimeRoutes do
  @moduledoc """
  Provides API endpoints related to sleep time routes
  """

  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponsePublicSleepTime
  alias ExOura.Client.PublicSleepTime
  alias ExOura.Client.SleepTimeRoutes

  @default_client ExOura.Client

  @doc """
  Multiple Sleep Time Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`
    * `fields`: Comma-separated list of fields to include in the response, in addition to the always returned fields. Defaults to all fields if not provided.

  """
  @spec multiple_sleep_time_documents_v2_usercollection_sleep_time_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicSleepTime.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_sleep_time_documents_v2_usercollection_sleep_time_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :fields, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SleepTimeRoutes, :multiple_sleep_time_documents_v2_usercollection_sleep_time_get},
      url: "/v2/usercollection/sleep_time",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicSleepTime, :t}
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
  Single Sleep Time Document
  """
  @spec single_sleep_time_document_v2_usercollection_sleep_time_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicSleepTime.t()}
          | {:error, HTTPValidationError.t()}
  def single_sleep_time_document_v2_usercollection_sleep_time_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SleepTimeRoutes, :single_sleep_time_document_v2_usercollection_sleep_time_document_id_get},
      url: "/v2/usercollection/sleep_time/#{document_id}",
      method: :get,
      response: [
        {200, {PublicSleepTime, :t}},
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
