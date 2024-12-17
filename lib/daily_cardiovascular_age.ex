defmodule ExOura.DailyCardiovascularAge do
  @moduledoc """

  """
  alias ExOura.Client

  @doc """
  Multiple Daily Cardiovascular Age
  """
  def multiple_daily_cardiovascular_age(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.DailyCardiovascularAgeRoutes,
      :multiple_daily_cardiovascular_age_documents_v2_usercollection_daily_cardiovascular_age_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Daily Cardiovascular Age
  """
  def single_daily_cardiovascular_age(document_id, opts \\ []) do
    Client.call_api(
      Client.DailyCardiovascularAgeRoutes,
      :single_daily_cardiovascular_age_document_v2_usercollection_daily_cardiovascular_age_document_id_get,
      document_id,
      opts
    )
  end
end
