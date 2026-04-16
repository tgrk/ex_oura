defmodule ExOura.Session do
  @moduledoc """
  Documentation for Oura API - Session
  """

  alias ExOura.Client

  @type start_date :: Date.t()
  @type end_date :: Date.t()
  @type next_token :: String.t() | nil
  @type document_id :: String.t()
  @type opts :: Keyword.t()
  @type session_response :: {:ok, Client.MultiDocumentResponsePublicSession.t()} | {:error, term()}
  @type single_session_response :: {:ok, Client.PublicSession.t()} | {:error, term()}

  @doc """
  Multiple Session
  """
  @spec multiple_session(start_date(), end_date(), next_token(), opts()) :: session_response()
  def multiple_session(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.SessionRoutes,
      :multiple_session_documents_v2_usercollection_session_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Session
  """
  @spec single_session(document_id(), opts()) :: single_session_response()
  def single_session(document_id, opts \\ []) do
    Client.call_api(
      Client.SessionRoutes,
      :single_session_document_v2_usercollection_session_document_id_get,
      document_id,
      opts
    )
  end
end
