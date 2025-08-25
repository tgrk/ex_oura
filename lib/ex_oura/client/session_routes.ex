defmodule ExOura.Client.SessionRoutes do
  @moduledoc """
  Provides API endpoints related to session routes
  """

  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseSessionModel
  alias ExOura.Client.SessionModel
  alias ExOura.Client.SessionRoutes

  @default_client ExOura.Client

  @doc """
  Multiple Session Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_session_documents_v2_usercollection_session_get(keyword) ::
          {:ok, MultiDocumentResponseSessionModel.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_session_documents_v2_usercollection_session_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SessionRoutes, :multiple_session_documents_v2_usercollection_session_get},
      url: "/v2/usercollection/session",
      method: :get,
      query: query,
      response: [
        {200, {MultiDocumentResponseSessionModel, :t}},
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
  Single Session Document
  """
  @spec single_session_document_v2_usercollection_session_document_id_get(String.t(), keyword) ::
          {:ok, SessionModel.t()} | {:error, HTTPValidationError.t()}
  def single_session_document_v2_usercollection_session_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SessionRoutes, :single_session_document_v2_usercollection_session_document_id_get},
      url: "/v2/usercollection/session/#{document_id}",
      method: :get,
      response: [
        {200, {SessionModel, :t}},
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
