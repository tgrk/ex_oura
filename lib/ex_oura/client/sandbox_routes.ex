defmodule ExOura.Client.SandboxRoutes do
  @moduledoc false
  alias ExOura.Client.DailyActivityModel
  alias ExOura.Client.DailyCardiovascularAgeModel
  alias ExOura.Client.DailyReadinessModel
  alias ExOura.Client.DailyResilienceModel
  alias ExOura.Client.DailySleepModel
  alias ExOura.Client.DailySpO2Model
  alias ExOura.Client.DailyStressModel
  alias ExOura.Client.EnhancedTagModel
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDailyActivityModel
  alias ExOura.Client.MultiDocumentResponseDailyCardiovascularAgeModel
  alias ExOura.Client.MultiDocumentResponseDailyReadinessModel
  alias ExOura.Client.MultiDocumentResponseDailyResilienceModel
  alias ExOura.Client.MultiDocumentResponseDailySleepModel
  alias ExOura.Client.MultiDocumentResponseDailySpO2Model
  alias ExOura.Client.MultiDocumentResponseDailyStressModel
  alias ExOura.Client.MultiDocumentResponseEnhancedTagModel
  alias ExOura.Client.MultiDocumentResponsePublicWorkout
  alias ExOura.Client.MultiDocumentResponseRestModePeriodModel
  alias ExOura.Client.MultiDocumentResponseRingConfigurationModel
  alias ExOura.Client.MultiDocumentResponseSessionModel
  alias ExOura.Client.MultiDocumentResponseSleepModel
  alias ExOura.Client.MultiDocumentResponseSleepTimeModel
  alias ExOura.Client.MultiDocumentResponseTagModel
  alias ExOura.Client.MultiDocumentResponseVo2MaxModel
  alias ExOura.Client.PublicWorkout
  alias ExOura.Client.RestModePeriodModel
  alias ExOura.Client.RingConfigurationModel
  alias ExOura.Client.SandboxRoutes
  alias ExOura.Client.SessionModel
  alias ExOura.Client.SleepModel
  alias ExOura.Client.SleepTimeModel
  alias ExOura.Client.TagModel
  alias ExOura.Client.TimeSeriesResponseHeartRateModel
  alias ExOura.Client.Vo2MaxModel

  @default_client ExOura.Client

  @doc """
  Sandbox - Multiple Daily Activity Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec sandbox_multiple_daily_activity_documents_v2_sandbox_usercollection_daily_activity_get(keyword) ::
          {:ok, MultiDocumentResponseDailyActivityModel.t()}
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
        {200, {MultiDocumentResponseDailyActivityModel, :t}},
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
          keyword
        ) ::
          {:ok, MultiDocumentResponseDailyCardiovascularAgeModel.t()}
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
        {200, {MultiDocumentResponseDailyCardiovascularAgeModel, :t}},
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
  @spec sandbox_multiple_daily_readiness_documents_v2_sandbox_usercollection_daily_readiness_get(keyword) ::
          {:ok, MultiDocumentResponseDailyReadinessModel.t()}
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
        {200, {MultiDocumentResponseDailyReadinessModel, :t}},
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
  @spec sandbox_multiple_daily_resilience_documents_v2_sandbox_usercollection_daily_resilience_get(keyword) ::
          {:ok, MultiDocumentResponseDailyResilienceModel.t()}
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
        {200, {MultiDocumentResponseDailyResilienceModel, :t}},
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
  @spec sandbox_multiple_daily_sleep_documents_v2_sandbox_usercollection_daily_sleep_get(keyword) ::
          {:ok, MultiDocumentResponseDailySleepModel.t()}
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
        {200, {MultiDocumentResponseDailySleepModel, :t}},
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
  @spec sandbox_multiple_daily_spo2_documents_v2_sandbox_usercollection_daily_spo2_get(keyword) ::
          {:ok, MultiDocumentResponseDailySpO2Model.t()}
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
        {200, {MultiDocumentResponseDailySpO2Model, :t}},
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
  @spec sandbox_multiple_daily_stress_documents_v2_sandbox_usercollection_daily_stress_get(keyword) ::
          {:ok, MultiDocumentResponseDailyStressModel.t()}
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
        {200, {MultiDocumentResponseDailyStressModel, :t}},
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
  @spec sandbox_multiple_enhanced_tag_documents_v2_sandbox_usercollection_enhanced_tag_get(keyword) ::
          {:ok, MultiDocumentResponseEnhancedTagModel.t()}
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
        {200, {MultiDocumentResponseEnhancedTagModel, :t}},
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
  @spec sandbox_multiple_heartrate_documents_v2_sandbox_usercollection_heartrate_get(keyword) ::
          {:ok, TimeSeriesResponseHeartRateModel.t()}
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
        {200, {TimeSeriesResponseHeartRateModel, :t}},
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
  @spec sandbox_multiple_rest_mode_period_documents_v2_sandbox_usercollection_rest_mode_period_get(keyword) ::
          {:ok, MultiDocumentResponseRestModePeriodModel.t()}
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
        {200, {MultiDocumentResponseRestModePeriodModel, :t}},
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
  @spec sandbox_multiple_ring_configuration_documents_v2_sandbox_usercollection_ring_configuration_get(keyword) ::
          {:ok, MultiDocumentResponseRingConfigurationModel.t()}
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
        {200, {MultiDocumentResponseRingConfigurationModel, :t}},
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
  @spec sandbox_multiple_session_documents_v2_sandbox_usercollection_session_get(keyword) ::
          {:ok, MultiDocumentResponseSessionModel.t()}
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
        {200, {MultiDocumentResponseSessionModel, :t}},
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
  @spec sandbox_multiple_sleep_documents_v2_sandbox_usercollection_sleep_get(keyword) ::
          {:ok, MultiDocumentResponseSleepModel.t()}
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
        {200, {MultiDocumentResponseSleepModel, :t}},
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
  @spec sandbox_multiple_sleep_time_documents_v2_sandbox_usercollection_sleep_time_get(keyword) ::
          {:ok, MultiDocumentResponseSleepTimeModel.t()}
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
        {200, {MultiDocumentResponseSleepTimeModel, :t}},
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
  @spec sandbox_multiple_tag_documents_v2_sandbox_usercollection_tag_get(keyword) ::
          {:ok, MultiDocumentResponseTagModel.t()}
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
        {200, {MultiDocumentResponseTagModel, :t}},
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
  @spec sandbox_multiple_v_o2_max_documents_v2_sandbox_usercollection_v_o2_max_get(keyword) ::
          {:ok, MultiDocumentResponseVo2MaxModel.t()}
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
        {200, {MultiDocumentResponseVo2MaxModel, :t}},
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
  @spec sandbox_multiple_workout_documents_v2_sandbox_usercollection_workout_get(keyword) ::
          {:ok, MultiDocumentResponsePublicWorkout.t()}
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
        {200, {MultiDocumentResponsePublicWorkout, :t}},
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
          String.t(),
          keyword
        ) ::
          {:ok, DailyActivityModel.t()}
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
        {200, {DailyActivityModel, :t}},
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
          String.t(),
          keyword
        ) ::
          {:ok, DailyCardiovascularAgeModel.t()}
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
        {200, {DailyCardiovascularAgeModel, :t}},
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
          String.t(),
          keyword
        ) ::
          {:ok, DailyReadinessModel.t()}
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
        {200, {DailyReadinessModel, :t}},
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
          String.t(),
          keyword
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
          String.t(),
          keyword
        ) ::
          {:ok, DailySleepModel.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_daily_sleep_document_v2_sandbox_usercollection_daily_sleep_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_daily_sleep_document_v2_sandbox_usercollection_daily_sleep_document_id_get},
      url: "/v2/sandbox/usercollection/daily_sleep/#{document_id}",
      method: :get,
      response: [
        {200, {DailySleepModel, :t}},
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
          String.t(),
          keyword
        ) ::
          {:ok, DailySpO2Model.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_daily_spo2_document_v2_sandbox_usercollection_daily_spo2_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_daily_spo2_document_v2_sandbox_usercollection_daily_spo2_document_id_get},
      url: "/v2/sandbox/usercollection/daily_spo2/#{document_id}",
      method: :get,
      response: [
        {200, {DailySpO2Model, :t}},
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
          String.t(),
          keyword
        ) ::
          {:ok, DailyStressModel.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_daily_stress_document_v2_sandbox_usercollection_daily_stress_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_daily_stress_document_v2_sandbox_usercollection_daily_stress_document_id_get},
      url: "/v2/sandbox/usercollection/daily_stress/#{document_id}",
      method: :get,
      response: [
        {200, {DailyStressModel, :t}},
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
          String.t(),
          keyword
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
          String.t(),
          keyword
        ) ::
          {:ok, RestModePeriodModel.t()}
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
        {200, {RestModePeriodModel, :t}},
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
          String.t(),
          keyword
        ) ::
          {:ok, RingConfigurationModel.t()}
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
        {200, {RingConfigurationModel, :t}},
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
          String.t(),
          keyword
        ) ::
          {:ok, SessionModel.t()} | {:error, HTTPValidationError.t()}
  def sandbox_single_session_document_v2_sandbox_usercollection_session_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_session_document_v2_sandbox_usercollection_session_document_id_get},
      url: "/v2/sandbox/usercollection/session/#{document_id}",
      method: :get,
      response: [
        {200, {SessionModel, :t}},
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
          String.t(),
          keyword
        ) :: {:ok, SleepModel.t()} | {:error, HTTPValidationError.t()}
  def sandbox_single_sleep_document_v2_sandbox_usercollection_sleep_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_sleep_document_v2_sandbox_usercollection_sleep_document_id_get},
      url: "/v2/sandbox/usercollection/sleep/#{document_id}",
      method: :get,
      response: [
        {200, {SleepModel, :t}},
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
          String.t(),
          keyword
        ) ::
          {:ok, SleepTimeModel.t()}
          | {:error, HTTPValidationError.t()}
  def sandbox_single_sleep_time_document_v2_sandbox_usercollection_sleep_time_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_sleep_time_document_v2_sandbox_usercollection_sleep_time_document_id_get},
      url: "/v2/sandbox/usercollection/sleep_time/#{document_id}",
      method: :get,
      response: [
        {200, {SleepTimeModel, :t}},
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
          String.t(),
          keyword
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
          String.t(),
          keyword
        ) ::
          {:ok, Vo2MaxModel.t()} | {:error, HTTPValidationError.t()}
  def sandbox_single_v_o2_max_document_v2_sandbox_usercollection_v_o2_max_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {SandboxRoutes, :sandbox_single_v_o2_max_document_v2_sandbox_usercollection_v_o2_max_document_id_get},
      url: "/v2/sandbox/usercollection/vO2_max/#{document_id}",
      method: :get,
      response: [
        {200, {Vo2MaxModel, :t}},
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
          String.t(),
          keyword
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
