defmodule ExOura.DailyActivity do
  @moduledoc """
  Documentation for Oura API - Daily Activity
  """

  alias ExOura.Client

  @doc """
  Multiple Daily Activity
  """
  def multiple_daily_activity(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.DailyActivityRoutes,
      :multiple_daily_activity_documents_v2_usercollection_daily_activity_get,
      [],
      [start_date: start_date, end_date: end_date, next_token: next_token] ++ opts
    )
  end

  @doc """
  Single Daily Activity
  """
  def single_daily_activity(document_id, opts \\ []) do
    Client.call_api(
      Client.DailyActivityRoutes,
      :single_daily_activity_document_v2_usercollection_daily_activity_document_id_get,
      document_id,
      opts
    )
  end
end
