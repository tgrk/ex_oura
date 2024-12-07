defmodule ExOura do
  @moduledoc """
  Documentation for Oura API
  """

  alias ExOura.DailyActivity
  alias ExOura.DailyCardiovascularAge

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
end
