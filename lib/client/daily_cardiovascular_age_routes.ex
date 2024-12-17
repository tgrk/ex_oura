defmodule ExOura.Client.DailyCardiovascularAgeRoutes do
  @moduledoc """
  Provides API endpoints related to daily cardiovascular age routes
  """

  @default_client ExOura.Client

  @doc """
  Multiple Daily Cardiovascular Age Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_daily_cardiovascular_age_documents_v2_usercollection_daily_cardiovascular_age_get(
          keyword
        ) ::
          {:ok, ExOura.Client.MultiDocumentResponseDailyCardiovascularAgeModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def multiple_daily_cardiovascular_age_documents_v2_usercollection_daily_cardiovascular_age_get(
        opts \\ []
      ) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call:
        {ExOura.Client.DailyCardiovascularAgeRoutes,
         :multiple_daily_cardiovascular_age_documents_v2_usercollection_daily_cardiovascular_age_get},
      url: "/v2/usercollection/daily_cardiovascular_age",
      method: :get,
      query: query,
      response: [
        {200, {ExOura.Client.MultiDocumentResponseDailyCardiovascularAgeModel, :t}},
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
  Single Daily Cardiovascular Age Document
  """
  @spec single_daily_cardiovascular_age_document_v2_usercollection_daily_cardiovascular_age_document_id_get(
          String.t(),
          keyword
        ) ::
          {:ok, ExOura.Client.DailyCardiovascularAgeModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def single_daily_cardiovascular_age_document_v2_usercollection_daily_cardiovascular_age_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {ExOura.Client.DailyCardiovascularAgeRoutes,
         :single_daily_cardiovascular_age_document_v2_usercollection_daily_cardiovascular_age_document_id_get},
      url: "/v2/usercollection/daily_cardiovascular_age/#{document_id}",
      method: :get,
      response: [
        {200, {ExOura.Client.DailyCardiovascularAgeModel, :t}},
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
