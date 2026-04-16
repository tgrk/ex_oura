defmodule ExOura.Client.SandboxRoutes do
  @moduledoc """
  Provides API endpoints related to sandbox routes
  """

  alias ExOura.Client.DailyResilienceModel
  alias ExOura.Client.EnhancedTagModel
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDailyResilienceModel
  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponseEnhancedTagModel
  alias ExOura.Client.MultiDocumentResponsePublicDailyActivity
  alias ExOura.Client.MultiDocumentResponsePublicDailyCardiovascularAge
  alias ExOura.Client.MultiDocumentResponsePublicDailyReadiness
  alias ExOura.Client.MultiDocumentResponsePublicDailySleep
  alias ExOura.Client.MultiDocumentResponsePublicDailySpO2
  alias ExOura.Client.MultiDocumentResponsePublicDailyStress
  alias ExOura.Client.MultiDocumentResponsePublicModifiedSleepModel
  alias ExOura.Client.MultiDocumentResponsePublicRestModePeriod
  alias ExOura.Client.MultiDocumentResponsePublicRingConfiguration
  alias ExOura.Client.MultiDocumentResponsePublicSession
  alias ExOura.Client.MultiDocumentResponsePublicSleepTime
  alias ExOura.Client.MultiDocumentResponsePublicVo2Max
  alias ExOura.Client.MultiDocumentResponsePublicWorkout
  alias ExOura.Client.MultiDocumentResponseTagModel
  alias ExOura.Client.PublicDailyActivity
  alias ExOura.Client.PublicDailyCardiovascularAge
  alias ExOura.Client.PublicDailyReadiness
  alias ExOura.Client.PublicDailySleep
  alias ExOura.Client.PublicDailySpO2
  alias ExOura.Client.PublicDailyStress
  alias ExOura.Client.PublicModifiedSleepModel
  alias ExOura.Client.PublicRestModePeriod
  alias ExOura.Client.PublicRingConfiguration
  alias ExOura.Client.PublicSession
  alias ExOura.Client.PublicSleepTime
  alias ExOura.Client.PublicVo2Max
  alias ExOura.Client.PublicWorkout
  alias ExOura.Client.SandboxRoutes
  alias ExOura.Client.TagModel
  alias ExOura.Client.TimeSeriesResponseDict
  alias ExOura.Client.TimeSeriesResponsePublicHeartRateRow
  alias ExOura.Client.TimeSeriesResponsePublicInterbeatIntervalRow
  alias ExOura.Client.TimeSeriesResponsePublicRingBatteryLevelRow

  @default_client ExOura.Client

  @doc """
  Sandbox - Multiple Daily Activity Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_daily_activity_documents_v2_sandbox_usercollection_daily_activity_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicDailyActivity.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_daily_activity_documents_v2_sandbox_usercollection_daily_activity_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_daily_activity_documents_v2_sandbox_usercollection_daily_activity_get},
      url: "/v2/sandbox/usercollection/daily_activity",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicDailyActivity, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Daily Cardiovascular Age Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_daily_cardiovascular_age_documents_v2_sandbox_usercollection_daily_cardiovascular_age_get(
          opts :: keyword
        ) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicDailyCardiovascularAge.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_daily_cardiovascular_age_documents_v2_sandbox_usercollection_daily_cardiovascular_age_get(
        opts \\ []
      ) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call:
        {SandboxRoutes,
         :sandbox_multiple_daily_cardiovascular_age_documents_v2_sandbox_usercollection_daily_cardiovascular_age_get},
      url: "/v2/sandbox/usercollection/daily_cardiovascular_age",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicDailyCardiovascularAge, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Daily Readiness Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_daily_readiness_documents_v2_sandbox_usercollection_daily_readiness_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicDailyReadiness.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_daily_readiness_documents_v2_sandbox_usercollection_daily_readiness_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_daily_readiness_documents_v2_sandbox_usercollection_daily_readiness_get},
      url: "/v2/sandbox/usercollection/daily_readiness",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicDailyReadiness, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Daily Resilience Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_daily_resilience_documents_v2_sandbox_usercollection_daily_resilience_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDailyResilienceModel.t()
           | MultiDocumentResponseDict.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_daily_resilience_documents_v2_sandbox_usercollection_daily_resilience_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_daily_resilience_documents_v2_sandbox_usercollection_daily_resilience_get},
      url: "/v2/sandbox/usercollection/daily_resilience",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDailyResilienceModel, :t},
            {MultiDocumentResponseDict, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Daily Sleep Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_daily_sleep_documents_v2_sandbox_usercollection_daily_sleep_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicDailySleep.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_daily_sleep_documents_v2_sandbox_usercollection_daily_sleep_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_daily_sleep_documents_v2_sandbox_usercollection_daily_sleep_get},
      url: "/v2/sandbox/usercollection/daily_sleep",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicDailySleep, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Daily Spo2 Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_daily_spo2_documents_v2_sandbox_usercollection_daily_spo2_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicDailySpO2.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_daily_spo2_documents_v2_sandbox_usercollection_daily_spo2_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_daily_spo2_documents_v2_sandbox_usercollection_daily_spo2_get},
      url: "/v2/sandbox/usercollection/daily_spo2",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicDailySpO2, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Daily Stress Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_daily_stress_documents_v2_sandbox_usercollection_daily_stress_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicDailyStress.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_daily_stress_documents_v2_sandbox_usercollection_daily_stress_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_daily_stress_documents_v2_sandbox_usercollection_daily_stress_get},
      url: "/v2/sandbox/usercollection/daily_stress",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicDailyStress, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Enhanced Tag Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_enhanced_tag_documents_v2_sandbox_usercollection_enhanced_tag_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponseEnhancedTagModel.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_enhanced_tag_documents_v2_sandbox_usercollection_enhanced_tag_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_enhanced_tag_documents_v2_sandbox_usercollection_enhanced_tag_get},
      url: "/v2/sandbox/usercollection/enhanced_tag",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponseEnhancedTagModel, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Heartrate Documents

  ## Options

    * `start_datetime`
    * `end_datetime`
    * `next_token`

  """
  @spec sandbox_multiple_heartrate_documents_v2_sandbox_usercollection_heartrate_get(opts :: keyword) ::
          {:ok,
           TimeSeriesResponseDict.t()
           | TimeSeriesResponsePublicHeartRateRow.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_heartrate_documents_v2_sandbox_usercollection_heartrate_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_datetime, :next_token, :start_datetime])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_heartrate_documents_v2_sandbox_usercollection_heartrate_get},
      url: "/v2/sandbox/usercollection/heartrate",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {TimeSeriesResponseDict, :t},
            {TimeSeriesResponsePublicHeartRateRow, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Interbeat Interval Documents

  ## Options

    * `start_datetime`
    * `end_datetime`
    * `next_token`

  """
  @spec sandbox_multiple_interbeat_interval_documents_v2_sandbox_usercollection_interbeat_interval_get(opts :: keyword) ::
          {:ok,
           TimeSeriesResponseDict.t()
           | TimeSeriesResponsePublicInterbeatIntervalRow.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_interbeat_interval_documents_v2_sandbox_usercollection_interbeat_interval_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_datetime, :next_token, :start_datetime])

    client.request(%{
      args: [],
      call:
        {SandboxRoutes, :sandbox_multiple_interbeat_interval_documents_v2_sandbox_usercollection_interbeat_interval_get},
      url: "/v2/sandbox/usercollection/interbeat_interval",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {TimeSeriesResponseDict, :t},
            {TimeSeriesResponsePublicInterbeatIntervalRow, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Rest Mode Period Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_rest_mode_period_documents_v2_sandbox_usercollection_rest_mode_period_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicRestModePeriod.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_rest_mode_period_documents_v2_sandbox_usercollection_rest_mode_period_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_rest_mode_period_documents_v2_sandbox_usercollection_rest_mode_period_get},
      url: "/v2/sandbox/usercollection/rest_mode_period",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicRestModePeriod, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Ring Battery Level Documents

  ## Options

    * `start_datetime`
    * `end_datetime`
    * `next_token`

  """
  @spec sandbox_multiple_ring_battery_level_documents_v2_sandbox_usercollection_ring_battery_level_get(opts :: keyword) ::
          {:ok,
           TimeSeriesResponseDict.t()
           | TimeSeriesResponsePublicRingBatteryLevelRow.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_ring_battery_level_documents_v2_sandbox_usercollection_ring_battery_level_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_datetime, :next_token, :start_datetime])

    client.request(%{
      args: [],
      call:
        {SandboxRoutes, :sandbox_multiple_ring_battery_level_documents_v2_sandbox_usercollection_ring_battery_level_get},
      url: "/v2/sandbox/usercollection/ring_battery_level",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {TimeSeriesResponseDict, :t},
            {TimeSeriesResponsePublicRingBatteryLevelRow, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Ring Configuration Documents

  ## Options

    * `next_token`

  """
  @spec sandbox_multiple_ring_configuration_documents_v2_sandbox_usercollection_ring_configuration_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicRingConfiguration.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_ring_configuration_documents_v2_sandbox_usercollection_ring_configuration_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:next_token])

    client.request(%{
      args: [],
      call:
        {SandboxRoutes, :sandbox_multiple_ring_configuration_documents_v2_sandbox_usercollection_ring_configuration_get},
      url: "/v2/sandbox/usercollection/ring_configuration",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicRingConfiguration, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Session Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_session_documents_v2_sandbox_usercollection_session_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicSession.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_session_documents_v2_sandbox_usercollection_session_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_session_documents_v2_sandbox_usercollection_session_get},
      url: "/v2/sandbox/usercollection/session",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicSession, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Sleep Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_sleep_documents_v2_sandbox_usercollection_sleep_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicModifiedSleepModel.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_sleep_documents_v2_sandbox_usercollection_sleep_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_sleep_documents_v2_sandbox_usercollection_sleep_get},
      url: "/v2/sandbox/usercollection/sleep",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicModifiedSleepModel, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Sleep Time Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_sleep_time_documents_v2_sandbox_usercollection_sleep_time_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicSleepTime.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_sleep_time_documents_v2_sandbox_usercollection_sleep_time_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_sleep_time_documents_v2_sandbox_usercollection_sleep_time_get},
      url: "/v2/sandbox/usercollection/sleep_time",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicSleepTime, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Tag Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_tag_documents_v2_sandbox_usercollection_tag_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponseTagModel.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_tag_documents_v2_sandbox_usercollection_tag_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_tag_documents_v2_sandbox_usercollection_tag_get},
      url: "/v2/sandbox/usercollection/tag",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponseTagModel, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Vo2 Max Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_v_o2_max_documents_v2_sandbox_usercollection_v_o2_max_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicVo2Max.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_v_o2_max_documents_v2_sandbox_usercollection_v_o2_max_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_v_o2_max_documents_v2_sandbox_usercollection_v_o2_max_get},
      url: "/v2/sandbox/usercollection/vO2_max",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicVo2Max, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Multiple Workout Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_workout_documents_v2_sandbox_usercollection_workout_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicWorkout.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_multiple_workout_documents_v2_sandbox_usercollection_workout_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {SandboxRoutes, :sandbox_multiple_workout_documents_v2_sandbox_usercollection_workout_get},
      url: "/v2/sandbox/usercollection/workout",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicWorkout, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Daily Activity Document
  """
  @spec sandbox_single_daily_activity_document_v2_sandbox_usercollection_daily_activity_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicDailyActivity.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_daily_activity_document_v2_sandbox_usercollection_daily_activity_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {SandboxRoutes, :sandbox_single_daily_activity_document_v2_sandbox_usercollection_daily_activity_document_id_get},
      url: "/v2/sandbox/usercollection/daily_activity/#{document_id}",
      method: :get,
      response: [
        {200, {PublicDailyActivity, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Daily Cardiovascular Age Document
  """
  @spec sandbox_single_daily_cardiovascular_age_document_v2_sandbox_usercollection_daily_cardiovascular_age_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicDailyCardiovascularAge.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_daily_cardiovascular_age_document_v2_sandbox_usercollection_daily_cardiovascular_age_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {SandboxRoutes,
         :sandbox_single_daily_cardiovascular_age_document_v2_sandbox_usercollection_daily_cardiovascular_age_document_id_get},
      url: "/v2/sandbox/usercollection/daily_cardiovascular_age/#{document_id}",
      method: :get,
      response: [
        {200, {PublicDailyCardiovascularAge, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Daily Readiness Document
  """
  @spec sandbox_single_daily_readiness_document_v2_sandbox_usercollection_daily_readiness_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicDailyReadiness.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_daily_readiness_document_v2_sandbox_usercollection_daily_readiness_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {SandboxRoutes,
         :sandbox_single_daily_readiness_document_v2_sandbox_usercollection_daily_readiness_document_id_get},
      url: "/v2/sandbox/usercollection/daily_readiness/#{document_id}",
      method: :get,
      response: [
        {200, {PublicDailyReadiness, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Daily Resilience Document
  """
  @spec sandbox_single_daily_resilience_document_v2_sandbox_usercollection_daily_resilience_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, DailyResilienceModel.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_daily_resilience_document_v2_sandbox_usercollection_daily_resilience_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {SandboxRoutes,
         :sandbox_single_daily_resilience_document_v2_sandbox_usercollection_daily_resilience_document_id_get},
      url: "/v2/sandbox/usercollection/daily_resilience/#{document_id}",
      method: :get,
      response: [
        {200, {DailyResilienceModel, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Daily Sleep Document
  """
  @spec sandbox_single_daily_sleep_document_v2_sandbox_usercollection_daily_sleep_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicDailySleep.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_daily_sleep_document_v2_sandbox_usercollection_daily_sleep_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_daily_sleep_document_v2_sandbox_usercollection_daily_sleep_document_id_get},
      url: "/v2/sandbox/usercollection/daily_sleep/#{document_id}",
      method: :get,
      response: [
        {200, {PublicDailySleep, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Daily Spo2 Document
  """
  @spec sandbox_single_daily_spo2_document_v2_sandbox_usercollection_daily_spo2_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicDailySpO2.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_daily_spo2_document_v2_sandbox_usercollection_daily_spo2_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_daily_spo2_document_v2_sandbox_usercollection_daily_spo2_document_id_get},
      url: "/v2/sandbox/usercollection/daily_spo2/#{document_id}",
      method: :get,
      response: [
        {200, {PublicDailySpO2, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Daily Stress Document
  """
  @spec sandbox_single_daily_stress_document_v2_sandbox_usercollection_daily_stress_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicDailyStress.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_daily_stress_document_v2_sandbox_usercollection_daily_stress_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_daily_stress_document_v2_sandbox_usercollection_daily_stress_document_id_get},
      url: "/v2/sandbox/usercollection/daily_stress/#{document_id}",
      method: :get,
      response: [
        {200, {PublicDailyStress, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Enhanced Tag Document
  """
  @spec sandbox_single_enhanced_tag_document_v2_sandbox_usercollection_enhanced_tag_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, EnhancedTagModel.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_enhanced_tag_document_v2_sandbox_usercollection_enhanced_tag_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_enhanced_tag_document_v2_sandbox_usercollection_enhanced_tag_document_id_get},
      url: "/v2/sandbox/usercollection/enhanced_tag/#{document_id}",
      method: :get,
      response: [
        {200, {EnhancedTagModel, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Rest Mode Period Document
  """
  @spec sandbox_single_rest_mode_period_document_v2_sandbox_usercollection_rest_mode_period_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicRestModePeriod.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_rest_mode_period_document_v2_sandbox_usercollection_rest_mode_period_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {SandboxRoutes,
         :sandbox_single_rest_mode_period_document_v2_sandbox_usercollection_rest_mode_period_document_id_get},
      url: "/v2/sandbox/usercollection/rest_mode_period/#{document_id}",
      method: :get,
      response: [
        {200, {PublicRestModePeriod, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Ring Configuration Document
  """
  @spec sandbox_single_ring_configuration_document_v2_sandbox_usercollection_ring_configuration_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicRingConfiguration.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_ring_configuration_document_v2_sandbox_usercollection_ring_configuration_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {SandboxRoutes,
         :sandbox_single_ring_configuration_document_v2_sandbox_usercollection_ring_configuration_document_id_get},
      url: "/v2/sandbox/usercollection/ring_configuration/#{document_id}",
      method: :get,
      response: [
        {200, {PublicRingConfiguration, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Session Document
  """
  @spec sandbox_single_session_document_v2_sandbox_usercollection_session_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicSession.t()} | {:error, HTTPValidationError.t()}
  def sandbox_single_session_document_v2_sandbox_usercollection_session_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_session_document_v2_sandbox_usercollection_session_document_id_get},
      url: "/v2/sandbox/usercollection/session/#{document_id}",
      method: :get,
      response: [
        {200, {PublicSession, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Sleep Document
  """
  @spec sandbox_single_sleep_document_v2_sandbox_usercollection_sleep_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicModifiedSleepModel.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_sleep_document_v2_sandbox_usercollection_sleep_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_sleep_document_v2_sandbox_usercollection_sleep_document_id_get},
      url: "/v2/sandbox/usercollection/sleep/#{document_id}",
      method: :get,
      response: [
        {200, {PublicModifiedSleepModel, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Sleep Time Document
  """
  @spec sandbox_single_sleep_time_document_v2_sandbox_usercollection_sleep_time_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicSleepTime.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_sleep_time_document_v2_sandbox_usercollection_sleep_time_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_sleep_time_document_v2_sandbox_usercollection_sleep_time_document_id_get},
      url: "/v2/sandbox/usercollection/sleep_time/#{document_id}",
      method: :get,
      response: [
        {200, {PublicSleepTime, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Tag Document
  """
  @spec sandbox_single_tag_document_v2_sandbox_usercollection_tag_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) :: {:ok, TagModel.t()} | {:error, HTTPValidationError.t()}
  def sandbox_single_tag_document_v2_sandbox_usercollection_tag_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_tag_document_v2_sandbox_usercollection_tag_document_id_get},
      url: "/v2/sandbox/usercollection/tag/#{document_id}",
      method: :get,
      response: [
        {200, {TagModel, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Vo2 Max Document
  """
  @spec sandbox_single_v_o2_max_document_v2_sandbox_usercollection_v_o2_max_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicVo2Max.t()} | {:error, HTTPValidationError.t()}
  def sandbox_single_v_o2_max_document_v2_sandbox_usercollection_v_o2_max_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_v_o2_max_document_v2_sandbox_usercollection_v_o2_max_document_id_get},
      url: "/v2/sandbox/usercollection/vO2_max/#{document_id}",
      method: :get,
      response: [
        {200, {PublicVo2Max, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Sandbox - Single Workout Document
  """
  @spec sandbox_single_workout_document_v2_sandbox_usercollection_workout_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicWorkout.t()} | {:error, HTTPValidationError.t()}
  def sandbox_single_workout_document_v2_sandbox_usercollection_workout_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_workout_document_v2_sandbox_usercollection_workout_document_id_get},
      url: "/v2/sandbox/usercollection/workout/#{document_id}",
      method: :get,
      response: [
        {200, {PublicWorkout, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end
end
