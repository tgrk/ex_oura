defmodule ExOura.Client.DailySpo2Routes do
  @moduledoc false
  alias ExOura.Client.DailySpO2Model
  alias ExOura.Client.DailySpo2Routes
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDailySpO2Model

  @default_client ExOura.Client

  @doc """
  Multiple Daily Spo2 Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_daily_spo2_documents_v2_usercollection_daily_spo2_get(keyword) ::
          {:ok, MultiDocumentResponseDailySpO2Model.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_daily_spo2_documents_v2_usercollection_daily_spo2_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {DailySpo2Routes, :multiple_daily_spo2_documents_v2_usercollection_daily_spo2_get},
      url: "/v2/usercollection/daily_spo2",
      method: :get,
      query: query,
      response: [
        {200, {MultiDocumentResponseDailySpO2Model, :t}},
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
  Single Daily Spo2 Document
  """
  @spec single_daily_spo2_document_v2_usercollection_daily_spo2_document_id_get(
          String.t(),
          keyword
        ) ::
          {:ok, DailySpO2Model.t()}
          | {:error, HTTPValidationError.t()}
  def single_daily_spo2_document_v2_usercollection_daily_spo2_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {DailySpo2Routes, :single_daily_spo2_document_v2_usercollection_daily_spo2_document_id_get},
      url: "/v2/usercollection/daily_spo2/#{document_id}",
      method: :get,
      response: [
        {200, {DailySpO2Model, :t}},
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
