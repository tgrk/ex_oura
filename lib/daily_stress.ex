defmodule ExOura.DailyStress do
  @moduledoc """
  Documentation for Oura API - Daily Stress
  """

  alias ExOura.Client

  @doc """
  Multiple Daily Stress
  """
  def multiple_daily_stress(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.DailyStressRoutes,
      :multiple_daily_stress_documents_v2_usercollection_daily_stress_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Daily Stress
  """
  def single_daily_stress(document_id, opts \\ []) do
    Client.call_api(
      Client.DailyStressRoutes,
      :single_daily_stress_document_v2_usercollection_daily_stress_document_id_get,
      document_id,
      opts
    )
  end
end
