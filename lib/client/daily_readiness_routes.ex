defmodule ExOura.Client.DailyReadinessRoutes do
  @moduledoc """
  Provides API endpoints related to daily readiness routes
  """

  @default_client ExOura.Client

  @doc """
  Multiple Daily Readiness Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_daily_readiness_documents_v2_usercollection_daily_readiness_get(keyword) ::
          {:ok, ExOura.Client.MultiDocumentResponseDailyReadinessModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def multiple_daily_readiness_documents_v2_usercollection_daily_readiness_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call:
        {ExOura.Client.DailyReadinessRoutes,
         :multiple_daily_readiness_documents_v2_usercollection_daily_readiness_get},
      url: "/v2/usercollection/daily_readiness",
      method: :get,
      query: query,
      response: [
        {200, {ExOura.Client.MultiDocumentResponseDailyReadinessModel, :t}},
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
  Single Daily Readiness Document
  """
  @spec single_daily_readiness_document_v2_usercollection_daily_readiness_document_id_get(
          String.t(),
          keyword
        ) ::
          {:ok, ExOura.Client.DailyReadinessModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def single_daily_readiness_document_v2_usercollection_daily_readiness_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {ExOura.Client.DailyReadinessRoutes,
         :single_daily_readiness_document_v2_usercollection_daily_readiness_document_id_get},
      url: "/v2/usercollection/daily_readiness/#{document_id}",
      method: :get,
      response: [
        {200, {ExOura.Client.DailyReadinessModel, :t}},
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
