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
  alias ExOura.EnhancedTag
  alias ExOura.HeartRate
  alias ExOura.PersonalInfo
  alias ExOura.RestModePeriod
  alias ExOura.RingConfiguration
  alias ExOura.Session
  alias ExOura.Sleep
  alias ExOura.SleepTime
  alias ExOura.Vo2Max
  alias ExOura.Workout

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

  @doc """
  Multiple Enhanced Tag
  """
  @spec multiple_enhanced_tag(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseEnhancedTagModel.t()} | error()
  defdelegate multiple_enhanced_tag(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: EnhancedTag

  @doc """
  Single Enhanced Tag
  """
  @spec single_enhanced_tag(document_id(), opts()) ::
          {:ok, Client.EnhancedTagModel.t()} | error()
  defdelegate single_enhanced_tag(document_id, opts \\ []), to: EnhancedTag

  @doc """
  Multiple Heart Rate
  """
  @spec multiple_heart_rate(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.TimeSeriesResponseHeartRateModel.t()} | error()
  defdelegate multiple_heart_rate(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: HeartRate

  @doc """
  Single Personal Info
  """
  @spec single_personal_info(opts()) :: {:ok, Client.PersonalInfoResponse.t()} | error()
  defdelegate single_personal_info(opts \\ []), to: PersonalInfo

  @doc """
  Multiple Rest Mode Period
  """
  @spec multiple_rest_mode_period(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseRestModePeriodModel.t()} | error()
  defdelegate multiple_rest_mode_period(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: RestModePeriod

  @doc """
  Single Rest Mode Period
  """
  @spec single_rest_mode_period(document_id(), opts()) ::
          {:ok, Client.RestModePeriodModel.t()} | error()
  defdelegate single_rest_mode_period(document_id, opts \\ []), to: RestModePeriod

  @doc """
  Multiple Ring Configuration
  """
  @spec multiple_ring_configuration(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseRingConfigurationModel.t()} | error()
  defdelegate multiple_ring_configuration(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: RingConfiguration

  @doc """
  Single Ring Configuration
  """
  @spec single_ring_configuration(document_id(), opts()) ::
          {:ok, Client.RingConfigurationModel.t()} | error()
  defdelegate single_ring_configuration(document_id, opts \\ []), to: RingConfiguration

  @doc """
  Multiple Session
  """
  @spec multiple_session(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseSessionModel.t()} | error()
  defdelegate multiple_session(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: Session

  @doc """
  Single Session
  """
  @spec single_session(document_id(), opts()) ::
          {:ok, Client.SessionModel.t()} | error()
  defdelegate single_session(document_id, opts \\ []), to: Session

  @doc """
  Multiple Sleep
  """
  @spec multiple_sleep(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseSleepModel.t()} | error()
  defdelegate multiple_sleep(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: Sleep

  @doc """
  Single Sleep
  """
  @spec single_sleep(document_id(), opts()) ::
          {:ok, Client.SleepModel.t()} | error()
  defdelegate single_sleep(document_id, opts \\ []), to: Sleep

  @doc """
  Multiple Sleep Time
  """
  @spec multiple_sleep_time(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseSleepTimeModel.t()} | error()
  defdelegate multiple_sleep_time(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: SleepTime

  @doc """
  Single Sleep Time
  """
  @spec single_sleep_time(document_id(), opts()) ::
          {:ok, Client.SleepTimeModel.t()} | error()
  defdelegate single_sleep_time(document_id, opts \\ []), to: SleepTime

  @doc """
  Multiple Vo2 Max
  """
  @spec multiple_vo2_max(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseVo2MaxModel.t()} | error()
  defdelegate multiple_vo2_max(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: Vo2Max

  @doc """
  Single Vo2 Max
  """
  @spec single_vo2_max(document_id(), opts()) ::
          {:ok, Client.Vo2MaxModel.t()} | error()
  defdelegate single_vo2_max(document_id, opts \\ []), to: Vo2Max

  @doc """
  Multiple Workout
  """
  @spec multiple_workout(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseWorkoutModel.t()} | error()
  defdelegate multiple_workout(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: Workout

  @doc """
  Single Workout
  """
  @spec single_workout(document_id(), opts()) ::
          {:ok, Client.WorkoutModel.t()} | error()
  defdelegate single_workout(document_id, opts \\ []), to: Workout
end
