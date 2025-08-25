defmodule ExOura.Vo2Max do
  @moduledoc """
  Documentation for Oura API - Vo2 Max
  """

  alias ExOura.Client

  @doc """
  Multiple Vo2 Max
  """
  def multiple_vo2_max(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.Vo2MaxRoutes,
      :multiple_v_o2_max_documents_v2_usercollection_v_o2_max_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Vo2 Max
  """
  def single_vo2_max(document_id, opts \\ []) do
    Client.call_api(
      Client.Vo2MaxRoutes,
      :single_v_o2_max_document_v2_usercollection_v_o2_max_document_id_get,
      document_id,
      opts
    )
  end
end
