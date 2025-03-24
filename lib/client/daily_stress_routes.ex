defmodule ExOura.Client.DailyStressRoutes do
  @moduledoc """
  Provides API endpoints related to daily stress routes
  """

  alias ExOura.Client.DailyStressModel
  alias ExOura.Client.DailyStressRoutes
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDailyStressModel

  @default_client ExOura.Client

  @doc """
  Multiple Daily Stress Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_daily_stress_documents_v2_usercollection_daily_stress_get(keyword) ::
          {:ok, MultiDocumentResponseDailyStressModel.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_daily_stress_documents_v2_usercollection_daily_stress_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {DailyStressRoutes, :multiple_daily_stress_documents_v2_usercollection_daily_stress_get},
      url: "/v2/usercollection/daily_stress",
      method: :get,
      query: query,
      response: [
        {200, {MultiDocumentResponseDailyStressModel, :t}},
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
  Single Daily Stress Document
  """
  @spec single_daily_stress_document_v2_usercollection_daily_stress_document_id_get(
          String.t(),
          keyword
        ) ::
          {:ok, DailyStressModel.t()}
          | {:error, HTTPValidationError.t()}
  def single_daily_stress_document_v2_usercollection_daily_stress_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {DailyStressRoutes, :single_daily_stress_document_v2_usercollection_daily_stress_document_id_get},
      url: "/v2/usercollection/daily_stress/#{document_id}",
      method: :get,
      response: [
        {200, {DailyStressModel, :t}},
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
