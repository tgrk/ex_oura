defmodule ExOura.Client.EnhancedTagRoutes do
  @moduledoc """
  Provides API endpoints related to enhanced tag routes
  """

  @default_client ExOura.Client

  @doc """
  Multiple Enhanced Tag Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_enhanced_tag_documents_v2_usercollection_enhanced_tag_get(keyword) ::
          {:ok, ExOura.Client.MultiDocumentResponseEnhancedTagModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def multiple_enhanced_tag_documents_v2_usercollection_enhanced_tag_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call:
        {ExOura.Client.EnhancedTagRoutes,
         :multiple_enhanced_tag_documents_v2_usercollection_enhanced_tag_get},
      url: "/v2/usercollection/enhanced_tag",
      method: :get,
      query: query,
      response: [
        {200, {ExOura.Client.MultiDocumentResponseEnhancedTagModel, :t}},
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
  Single Enhanced Tag Document
  """
  @spec single_enhanced_tag_document_v2_usercollection_enhanced_tag_document_id_get(
          String.t(),
          keyword
        ) ::
          {:ok, ExOura.Client.EnhancedTagModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def single_enhanced_tag_document_v2_usercollection_enhanced_tag_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {ExOura.Client.EnhancedTagRoutes,
         :single_enhanced_tag_document_v2_usercollection_enhanced_tag_document_id_get},
      url: "/v2/usercollection/enhanced_tag/#{document_id}",
      method: :get,
      response: [
        {200, {ExOura.Client.EnhancedTagModel, :t}},
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
