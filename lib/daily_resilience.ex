defmodule ExOura.DailyResilience do
  @moduledoc """
  Documentation for Oura API - Daily Resilience
  """

  alias ExOura.Client

  @doc """
  Multiple Daily Resilience
  """
  def multiple_daily_resilience(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.DailyResilienceRoutes,
      :multiple_daily_resilience_documents_v2_usercollection_daily_resilience_get,
      [],
      [start_date: start_date, end_date: end_date, next_token: next_token] ++ opts
    )
  end

  @doc """
  Single Daily Resilience
  """
  def single_daily_resilience(document_id, opts \\ []) do
    Client.call_api(
      Client.DailyResilienceRoutes,
      :single_daily_resilience_document_v2_usercollection_daily_resilience_document_id_get,
      document_id,
      opts
    )
  end
end
