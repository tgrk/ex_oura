defmodule ExOura.Client.RestModePeriodRoutes do
  @moduledoc """
  Provides API endpoints related to rest mode period routes
  """

  @default_client ExOura.Client

  @doc """
  Multiple Rest Mode Period Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_rest_mode_period_documents_v2_usercollection_rest_mode_period_get(keyword) ::
          {:ok, ExOura.Client.MultiDocumentResponseRestModePeriodModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def multiple_rest_mode_period_documents_v2_usercollection_rest_mode_period_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call:
        {ExOura.Client.RestModePeriodRoutes,
         :multiple_rest_mode_period_documents_v2_usercollection_rest_mode_period_get},
      url: "/v2/usercollection/rest_mode_period",
      method: :get,
      query: query,
      response: [
        {200, {ExOura.Client.MultiDocumentResponseRestModePeriodModel, :t}},
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
  Single Rest Mode Period Document
  """
  @spec single_rest_mode_period_document_v2_usercollection_rest_mode_period_document_id_get(
          String.t(),
          keyword
        ) ::
          {:ok, ExOura.Client.RestModePeriodModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def single_rest_mode_period_document_v2_usercollection_rest_mode_period_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {ExOura.Client.RestModePeriodRoutes,
         :single_rest_mode_period_document_v2_usercollection_rest_mode_period_document_id_get},
      url: "/v2/usercollection/rest_mode_period/#{document_id}",
      method: :get,
      response: [
        {200, {ExOura.Client.RestModePeriodModel, :t}},
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