defmodule ExOura.DailyReadiness do
  @moduledoc """
  Documentation for Oura API - Daily Readiness
  """

  alias ExOura.Client

  @doc """
  Multiple Daily Readiness
  """
  def multiple_daily_readiness(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.DailyReadinessRoutes,
      :multiple_daily_readiness_documents_v2_usercollection_daily_readiness_get,
      [],
      [start_date: start_date, end_date: end_date, next_token: next_token] ++ opts
    )
  end

  @doc """
  Single Daily Readiness
  """
  def single_daily_readiness(document_id, opts \\ []) do
    Client.call_api(
      Client.DailyReadinessRoutes,
      :single_daily_readiness_document_v2_usercollection_daily_readiness_document_id_get,
      document_id,
      opts
    )
  end
end
