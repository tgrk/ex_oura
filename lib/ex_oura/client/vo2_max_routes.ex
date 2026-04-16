defmodule ExOura.Client.Vo2MaxRoutes do
  @moduledoc """
  Provides API endpoints related to vo2 max routes
  """

  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponsePublicVo2Max
  alias ExOura.Client.PublicVo2Max
  alias ExOura.Client.Vo2MaxRoutes

  @default_client ExOura.Client

  @doc """
  Multiple Vo2 Max Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`
    * `fields`: Comma-separated list of fields to include in the response, in addition to the always returned fields. Defaults to all fields if not provided.

  """
  @spec multiple_v_o2_max_documents_v2_usercollection_v_o2_max_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicVo2Max.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_v_o2_max_documents_v2_usercollection_v_o2_max_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :fields, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {Vo2MaxRoutes, :multiple_v_o2_max_documents_v2_usercollection_v_o2_max_get},
      url: "/v2/usercollection/vO2_max",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicVo2Max, :t}
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
  Single Vo2 Max Document
  """
  @spec single_v_o2_max_document_v2_usercollection_v_o2_max_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicVo2Max.t()} | {:error, HTTPValidationError.t()}
  def single_v_o2_max_document_v2_usercollection_v_o2_max_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {Vo2MaxRoutes, :single_v_o2_max_document_v2_usercollection_v_o2_max_document_id_get},
      url: "/v2/usercollection/vO2_max/#{document_id}",
      method: :get,
      response: [
        {200, {PublicVo2Max, :t}},
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
