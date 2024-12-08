defmodule ExOura do
  @moduledoc """
  Documentation for Oura API
  """

  alias ExOura.DailyActivity
  alias ExOura.DailyCardiovascularAge
  alias ExOura.DailyReadiness

  @doc """
  Multiple Daily Activity
  """
  defdelegate multiple_daily_activity(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: DailyActivity

  @doc """
  Single Daily Activity
  """
  defdelegate single_daily_activity(document_id, opts \\ []), to: DailyActivity

  @doc """
  Multiple Daily Cardiovascular Age
  """
  defdelegate multiple_daily_cardiovascular_age(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: DailyCardiovascularAge

  @doc """
  Single Daily Cardiovascular Age
  """
  defdelegate single_daily_cardiovascular_age(document_id, opts \\ []), to: DailyCardiovascularAge

  @doc """
  Multiple Daily Readiness
  """
  defdelegate multiple_daily_readiness(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: DailyReadiness

  @doc """
  Single Daily Readiness
  """
  defdelegate single_daily_readiness(document_id, opts \\ []), to: DailyReadiness
end
