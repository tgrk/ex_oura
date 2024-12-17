defmodule ExOura.SleepTime do
  @moduledoc """
  Documentation for Oura API - Sleep Time
  """

  alias ExOura.Client

  @doc """
  Multiple Sleep Time
  """
  def multiple_sleep_time(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.SleepTimeRoutes,
      :multiple_sleep_time_documents_v2_usercollection_sleep_time_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Sleep Time
  """
  def single_sleep_time(document_id, opts \\ []) do
    Client.call_api(
      Client.SleepTimeRoutes,
      :single_sleep_time_document_v2_usercollection_sleep_time_document_id_get,
      document_id,
      opts
    )
  end
end
