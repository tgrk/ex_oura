defmodule ExOura.DailySleep do
  @moduledoc """
  Documentation for Oura API - Daily Sleep
  """

  alias ExOura.Client

  @doc """
  Multiple Daily Sleep
  """
  def multiple_daily_sleep(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.DailySleepRoutes,
      :multiple_daily_sleep_documents_v2_usercollection_daily_sleep_get,
      [],
      [start_date: start_date, end_date: end_date, next_token: next_token] ++ opts
    )
  end

  @doc """
  Single Daily Sleep
  """
  def single_daily_sleep(document_id, opts \\ []) do
    Client.call_api(
      Client.DailySleepRoutes,
      :single_daily_sleep_document_v2_usercollection_daily_sleep_document_id_get,
      document_id,
      opts
    )
  end
end
