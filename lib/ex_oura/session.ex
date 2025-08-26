defmodule ExOura.Session do
  @moduledoc """
  Documentation for Oura API - Session
  """

  alias ExOura.Client

  @doc """
  Multiple Session
  """
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
  def single_session(document_id, opts \\ []) do
    Client.call_api(
      Client.SessionRoutes,
      :single_session_document_v2_usercollection_session_document_id_get,
      document_id,
      opts
    )
  end
end
