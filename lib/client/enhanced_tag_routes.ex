defmodule ExOura.Client.EnhancedTagRoutes do
  @moduledoc """
  Provides API endpoints related to enhanced tag routes
  """

  alias ExOura.Client.EnhancedTagModel
  alias ExOura.Client.EnhancedTagRoutes
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseEnhancedTagModel

  @default_client ExOura.Client

  @doc """
  Multiple Enhanced Tag Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_enhanced_tag_documents_v2_usercollection_enhanced_tag_get(keyword) ::
          {:ok, MultiDocumentResponseEnhancedTagModel.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_enhanced_tag_documents_v2_usercollection_enhanced_tag_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {EnhancedTagRoutes, :multiple_enhanced_tag_documents_v2_usercollection_enhanced_tag_get},
      url: "/v2/usercollection/enhanced_tag",
      method: :get,
      query: query,
      response: [
        {200, {MultiDocumentResponseEnhancedTagModel, :t}},
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
  Single Enhanced Tag Document
  """
  @spec single_enhanced_tag_document_v2_usercollection_enhanced_tag_document_id_get(
          String.t(),
          keyword
        ) ::
          {:ok, EnhancedTagModel.t()}
          | {:error, HTTPValidationError.t()}
  def single_enhanced_tag_document_v2_usercollection_enhanced_tag_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {EnhancedTagRoutes, :single_enhanced_tag_document_v2_usercollection_enhanced_tag_document_id_get},
      url: "/v2/usercollection/enhanced_tag/#{document_id}",
      method: :get,
      response: [
        {200, {EnhancedTagModel, :t}},
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
