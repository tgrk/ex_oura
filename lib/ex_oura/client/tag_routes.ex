defmodule ExOura.Client.TagRoutes do
  @moduledoc """
  Provides API endpoints related to tag routes
  """

  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponseTagModel
  alias ExOura.Client.TagModel
  alias ExOura.Client.TagRoutes

  @default_client ExOura.Client

  @doc """
  Multiple Tag Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`
    * `fields`: N/A. This route does not support field selection yet, all fields will be returned.

  """
  @spec multiple_tag_documents_v2_usercollection_tag_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponseTagModel.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_tag_documents_v2_usercollection_tag_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :fields, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {TagRoutes, :multiple_tag_documents_v2_usercollection_tag_get},
      url: "/v2/usercollection/tag",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponseTagModel, :t}
          ]}},
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
  Single Tag Document
  """
  @spec single_tag_document_v2_usercollection_tag_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) :: {:ok, TagModel.t()} | {:error, HTTPValidationError.t()}
  def single_tag_document_v2_usercollection_tag_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {TagRoutes, :single_tag_document_v2_usercollection_tag_document_id_get},
      url: "/v2/usercollection/tag/#{document_id}",
      method: :get,
      response: [
        {200, {TagModel, :t}},
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
