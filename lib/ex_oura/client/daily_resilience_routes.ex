defmodule ExOura.Client.DailyResilienceRoutes do
  @moduledoc false
  alias ExOura.Client.DailyResilienceModel
  alias ExOura.Client.DailyResilienceRoutes
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDailyResilienceModel

  @default_client ExOura.Client

  @doc """
  Multiple Daily Resilience Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_daily_resilience_documents_v2_usercollection_daily_resilience_get(keyword) ::
          {:ok, MultiDocumentResponseDailyResilienceModel.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_daily_resilience_documents_v2_usercollection_daily_resilience_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {DailyResilienceRoutes, :multiple_daily_resilience_documents_v2_usercollection_daily_resilience_get},
      url: "/v2/usercollection/daily_resilience",
      method: :get,
      query: query,
      response: [
        {200, {MultiDocumentResponseDailyResilienceModel, :t}},
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
  Single Daily Resilience Document
  """
  @spec single_daily_resilience_document_v2_usercollection_daily_resilience_document_id_get(
          String.t(),
          keyword
        ) ::
          {:ok, DailyResilienceModel.t()}
          | {:error, HTTPValidationError.t()}
  def single_daily_resilience_document_v2_usercollection_daily_resilience_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {DailyResilienceRoutes, :single_daily_resilience_document_v2_usercollection_daily_resilience_document_id_get},
      url: "/v2/usercollection/daily_resilience/#{document_id}",
      method: :get,
      response: [
        {200, {DailyResilienceModel, :t}},
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
