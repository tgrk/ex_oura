defmodule ExOura.Sleep do
  @moduledoc """
  Documentation for Oura API - Sleep
  """

  alias ExOura.Client

  @doc """
  Multiple Sleep
  """
  def multiple_sleep(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.SleepRoutes,
      :multiple_sleep_documents_v2_usercollection_sleep_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Sleep
  """
  def single_sleep(document_id, opts \\ []) do
    Client.call_api(
      Client.SleepRoutes,
      :single_sleep_document_v2_usercollection_sleep_document_id_get,
      document_id,
      opts
    )
  end
end
