defmodule ExOura do
  @moduledoc """
  Documentation for Oura API
  """

  alias ExOura.Client
  alias ExOura.DailyActivity
  alias ExOura.DailyCardiovascularAge
  alias ExOura.DailyReadiness
  alias ExOura.DailyResilience
  alias ExOura.DailySleep
  alias ExOura.DailySp02
  alias ExOura.DailyStress

  @type start_date() :: Date.t()
  @type end_date() :: Date.t()
  @type next_token() :: String.t() | nil
  @type document_id() :: String.t()
  @type opts() :: Keyword.t()

  @type error() :: {:error, Client.HTTPValidationError.t()}

  @doc """
  Multiple Daily Activity
  """
  @spec multiple_daily_activity(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseDailyActivityModel.t()} | error()
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
  @spec single_daily_activity(document_id(), opts()) ::
          {:ok, Client.DailyActivityModel.t()} | error()
  defdelegate single_daily_activity(document_id, opts \\ []), to: DailyActivity

  @doc """
  Multiple Daily Cardiovascular Age
  """
  @spec multiple_daily_cardiovascular_age(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseDailyCardiovascularAgeModel.t()} | error()
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
  @spec single_daily_cardiovascular_age(document_id(), opts()) ::
          {:ok, Client.DailyCardiovascularAgeModel.t()} | error()
  defdelegate single_daily_cardiovascular_age(document_id, opts \\ []), to: DailyCardiovascularAge

  @doc """
  Multiple Daily Readiness
  """
  @spec multiple_daily_readiness(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseDailyReadinessModel.t()} | error()
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
  @spec single_daily_readiness(document_id(), opts()) ::
          {:ok, Client.DailyReadinessModel.t()} | error()
  defdelegate single_daily_readiness(document_id, opts \\ []), to: DailyReadiness

  @doc """
  Multiple Daily Resilience
  """
  @spec multiple_daily_resilience(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseDailyResilienceModel.t()} | error()
  defdelegate multiple_daily_resilience(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: DailyResilience

  @doc """
  Single Daily Resilience
  """
  @spec single_daily_resilience(document_id(), opts()) ::
          {:ok, Client.DailyResilienceModel.t()} | error()
  defdelegate single_daily_resilience(document_id, opts \\ []), to: DailyResilience

  @doc """
  Multiple Daily Sleep
  """
  @spec multiple_daily_sleep(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseDailySleepModel.t()} | error()
  defdelegate multiple_daily_sleep(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: DailySleep

  @doc """
  Single Daily Sleep
  """
  @spec single_daily_sleep(document_id(), opts()) ::
          {:ok, Client.DailySleepModel.t()} | error()
  defdelegate single_daily_sleep(document_id, opts \\ []), to: DailySleep

  @doc """
  Multiple Daily Sp02
  """
  @spec multiple_daily_sp02(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseDailySpO2Model.t()} | error()
  defdelegate multiple_daily_sp02(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: DailySp02

  @doc """
  Single Daily Sp02
  """
  @spec single_daily_sp02(document_id(), opts()) ::
          {:ok, Client.DailySpO2Model.t()} | error()
  defdelegate single_daily_sp02(document_id, opts \\ []), to: DailySp02

  @doc """
  Multiple Daily Stress
  """
  @spec multiple_daily_stress(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseDailyStressModel.t()} | error()
  defdelegate multiple_daily_stress(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: DailyStress

  @doc """
  Single Daily Stress
  """
  @spec single_daily_stress(document_id(), opts()) ::
          {:ok, Client.DailyStressModel.t()} | error()
  defdelegate single_daily_stress(document_id, opts \\ []), to: DailyStress
end
