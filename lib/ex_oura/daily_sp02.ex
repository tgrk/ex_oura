defmodule ExOura.DailySp02 do
  @moduledoc """
  Documentation for Oura API - Daily Sp02
  """

  alias ExOura.Client

  @doc """
  Multiple Daily Sp02
  """
  def multiple_daily_sp02(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.DailySpo2Routes,
      :multiple_daily_spo2_documents_v2_usercollection_daily_spo2_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Daily Sp02
  """
  def single_daily_sp02(document_id, opts \\ []) do
    Client.call_api(
      Client.DailySpo2Routes,
      :single_daily_spo2_document_v2_usercollection_daily_spo2_document_id_get,
      document_id,
      opts
    )
  end
end
