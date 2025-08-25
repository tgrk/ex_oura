defmodule ExOura.Client.SleepRoutes do
  @moduledoc """
  Provides API endpoints related to sleep routes
  """

  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseSleepModel
  alias ExOura.Client.SleepModel
  alias ExOura.Client.SleepRoutes

  @default_client ExOura.Client

  @doc """
  Multiple Sleep Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_sleep_documents_v2_usercollection_sleep_get(keyword) ::
          {:ok, MultiDocumentResponseSleepModel.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_sleep_documents_v2_usercollection_sleep_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SleepRoutes, :multiple_sleep_documents_v2_usercollection_sleep_get},
      url: "/v2/usercollection/sleep",
      method: :get,
      query: query,
      response: [
        {200, {MultiDocumentResponseSleepModel, :t}},
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
  Single Sleep Document
  """
  @spec single_sleep_document_v2_usercollection_sleep_document_id_get(String.t(), keyword) ::
          {:ok, SleepModel.t()} | {:error, HTTPValidationError.t()}
  def single_sleep_document_v2_usercollection_sleep_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SleepRoutes, :single_sleep_document_v2_usercollection_sleep_document_id_get},
      url: "/v2/usercollection/sleep/#{document_id}",
      method: :get,
      response: [
        {200, {SleepModel, :t}},
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
