defmodule ExOura.Client.TagRoutes do
  @moduledoc """
  Provides API endpoints related to tag routes
  """

  @default_client ExOura.Client

  @doc """
  Multiple Tag Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_tag_documents_v2_usercollection_tag_get(keyword) ::
          {:ok, ExOura.Client.MultiDocumentResponseTagModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def multiple_tag_documents_v2_usercollection_tag_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {ExOura.Client.TagRoutes, :multiple_tag_documents_v2_usercollection_tag_get},
      url: "/v2/usercollection/tag",
      method: :get,
      query: query,
      response: [
        {200, {ExOura.Client.MultiDocumentResponseTagModel, :t}},
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
  Single Tag Document
  """
  @spec single_tag_document_v2_usercollection_tag_document_id_get(String.t(), keyword) ::
          {:ok, ExOura.Client.TagModel.t()} | {:error, ExOura.Client.HTTPValidationError.t()}
  def single_tag_document_v2_usercollection_tag_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {ExOura.Client.TagRoutes, :single_tag_document_v2_usercollection_tag_document_id_get},
      url: "/v2/usercollection/tag/#{document_id}",
      method: :get,
      response: [
        {200, {ExOura.Client.TagModel, :t}},
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
