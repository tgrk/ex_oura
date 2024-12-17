defmodule ExOura.Client.DailyStressRoutes do
  @moduledoc """
  Provides API endpoints related to daily stress routes
  """

  @default_client ExOura.Client

  @doc """
  Multiple Daily Stress Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_daily_stress_documents_v2_usercollection_daily_stress_get(keyword) ::
          {:ok, ExOura.Client.MultiDocumentResponseDailyStressModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def multiple_daily_stress_documents_v2_usercollection_daily_stress_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call:
        {ExOura.Client.DailyStressRoutes,
         :multiple_daily_stress_documents_v2_usercollection_daily_stress_get},
      url: "/v2/usercollection/daily_stress",
      method: :get,
      query: query,
      response: [
        {200, {ExOura.Client.MultiDocumentResponseDailyStressModel, :t}},
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
  Single Daily Stress Document
  """
  @spec single_daily_stress_document_v2_usercollection_daily_stress_document_id_get(
          String.t(),
          keyword
        ) ::
          {:ok, ExOura.Client.DailyStressModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def single_daily_stress_document_v2_usercollection_daily_stress_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {ExOura.Client.DailyStressRoutes,
         :single_daily_stress_document_v2_usercollection_daily_stress_document_id_get},
      url: "/v2/usercollection/daily_stress/#{document_id}",
      method: :get,
      response: [
        {200, {ExOura.Client.DailyStressModel, :t}},
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
