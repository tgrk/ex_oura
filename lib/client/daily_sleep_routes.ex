defmodule ExOura.Client.DailySleepRoutes do
  @moduledoc """
  Provides API endpoints related to daily sleep routes
  """

  @default_client ExOura.Client

  @doc """
  Multiple Daily Sleep Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_daily_sleep_documents_v2_usercollection_daily_sleep_get(keyword) ::
          {:ok, ExOura.Client.MultiDocumentResponseDailySleepModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def multiple_daily_sleep_documents_v2_usercollection_daily_sleep_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call:
        {ExOura.Client.DailySleepRoutes,
         :multiple_daily_sleep_documents_v2_usercollection_daily_sleep_get},
      url: "/v2/usercollection/daily_sleep",
      method: :get,
      query: query,
      response: [
        {200, {ExOura.Client.MultiDocumentResponseDailySleepModel, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {ExOura.Client.HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Single Daily Sleep Document
  """
  @spec single_daily_sleep_document_v2_usercollection_daily_sleep_document_id_get(
          String.t(),
          keyword
        ) ::
          {:ok, ExOura.Client.DailySleepModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def single_daily_sleep_document_v2_usercollection_daily_sleep_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {ExOura.Client.DailySleepRoutes,
         :single_daily_sleep_document_v2_usercollection_daily_sleep_document_id_get},
      url: "/v2/usercollection/daily_sleep/#{document_id}",
      method: :get,
      response: [
        {200, {ExOura.Client.DailySleepModel, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {ExOura.Client.HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end
end