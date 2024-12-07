defmodule ExOura.Client.Vo2MaxRoutes do
  @moduledoc """
  Provides API endpoints related to vo2 max routes
  """

  @default_client ExOura.Client

  @doc """
  Multiple Vo2 Max Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_v_o2_max_documents_v2_usercollection_v_o2_max_get(keyword) ::
          {:ok, ExOura.Client.MultiDocumentResponseVo2MaxModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def multiple_v_o2_max_documents_v2_usercollection_v_o2_max_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call:
        {ExOura.Client.Vo2MaxRoutes, :multiple_v_o2_max_documents_v2_usercollection_v_o2_max_get},
      url: "/v2/usercollection/vO2_max",
      method: :get,
      query: query,
      response: [
        {200, {ExOura.Client.MultiDocumentResponseVo2MaxModel, :t}},
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
  Single Vo2 Max Document
  """
  @spec single_v_o2_max_document_v2_usercollection_v_o2_max_document_id_get(String.t(), keyword) ::
          {:ok, ExOura.Client.Vo2MaxModel.t()} | {:error, ExOura.Client.HTTPValidationError.t()}
  def single_v_o2_max_document_v2_usercollection_v_o2_max_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {ExOura.Client.Vo2MaxRoutes,
         :single_v_o2_max_document_v2_usercollection_v_o2_max_document_id_get},
      url: "/v2/usercollection/vO2_max/#{document_id}",
      method: :get,
      response: [
        {200, {ExOura.Client.Vo2MaxModel, :t}},
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
