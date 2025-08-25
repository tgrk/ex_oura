defmodule ExOura do
  @moduledoc """
  Documentation for Oura API

  ## Configuration

  ExOura can be configured in your config files:

      config :ex_oura,
        timeout: 10_000,
        rate_limiting: [
          enabled: true,          # Enable/disable rate limiting (default: true)
          daily_limit: 5000,      # Daily request limit (default: 5000)
          per_minute_limit: 300   # Per-minute request limit (default: 300)
        ],
        retry: [
          max_retries: 3          # Maximum retry attempts (default: 3)
        ],
        oauth2: [
          client_id: "your_client_id",
          client_secret: "your_client_secret",
          redirect_uri: "your_redirect_uri"
        ]

  ## OAuth2 Authentication (Recommended)

  ExOura supports OAuth2 authentication, which is the recommended approach since
  Personal Access Tokens are being deprecated by Oura by the end of 2025.

  ### OAuth2 Setup

  1. Register your application at https://cloud.ouraring.com/oauth/applications
  2. Configure your OAuth2 credentials (see Configuration above)
  3. Implement the OAuth2 flow in your application

  ### OAuth2 Flow Example

      # Step 1: Generate authorization URL
      authorization_url = ExOura.OAuth2.authorization_url([
        scopes: ["daily", "heartrate", "personal"],
        state: "your_state_parameter"
      ])

      # Step 2: After user authorizes, exchange code for tokens
      {:ok, tokens} = ExOura.OAuth2.get_token("authorization_code_from_callback")

      # Step 3: Use tokens with the client
      {:ok, client} = ExOura.Client.start_link([
        access_token: tokens.access_token,
        refresh_token: tokens.refresh_token
      ])

      # Step 4: Make API calls
      {:ok, activity_data} = ExOura.multiple_daily_activity(~D[2025-01-01], ~D[2025-01-31])

      # Step 5: Refresh tokens when needed
      if ExOura.OAuth2.token_expired?(tokens) do
        {:ok, new_tokens} = ExOura.OAuth2.refresh_token(tokens.refresh_token)
        # Update your stored tokens...
      end

  ### Rate Limiting

  Rate limiting is enabled by default and follows the Oura API limits:
  - 5000 requests per day
  - 300 requests per minute

  You can disable rate limiting entirely by setting `enabled: false` in the configuration,
  or adjust the limits if needed. When disabled, the client will not track or enforce
  any rate limits, but will still handle rate limit responses from the API server
  in the retry logic.

  ### Retry Logic

  ExOura uses Req's built-in retry mechanism with intelligent error handling:
  - Automatically retries on server errors (5xx), timeouts (408), and rate limits (429)
  - Exponential backoff with jitter to avoid thundering herd problems
  - Configurable maximum retry attempts
  - Does not retry on client errors (4xx except 408 and 429)
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
  alias ExOura.OAuth2
  alias ExOura.Pagination
  alias ExOura.PersonalInfo
  alias ExOura.RestModePeriod
  alias ExOura.RingConfiguration
  alias ExOura.Session
  alias ExOura.Sleep
  alias ExOura.SleepTime
  alias ExOura.Tag
  alias ExOura.Vo2Max
  alias ExOura.WebhookSubscription
  alias ExOura.Workout

  @type opts() :: Keyword.t()
  @type start_date() :: Date.t()
  @type end_date() :: Date.t()
  @type next_token() :: String.t() | nil
  @type document_id() :: String.t()
  @type webhook_id() :: String.t()
  @type webhook() ::
          Client.CreateWebhookSubscriptionRequest.t()
          | Client.UpdateWebhookSubscriptionRequest.t()

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

  @doc """
  Create Webhook Subscription
  """
  @spec create_webhook_subscription(webhook(), opts()) ::
          {:ok, Client.WebhookSubscriptionModel.t()} | error()
  defdelegate create_webhook_subscription(webhook, opts \\ []), to: WebhookSubscription

  @doc """
  Get Webhook Subscription
  """
  @spec get_webhook_subscription(webhook_id(), opts()) ::
          {:ok, Client.WebhookSubscriptionModel.t()} | error()
  defdelegate get_webhook_subscription(webhook_id, opts \\ []), to: WebhookSubscription

  @doc """
  Delete Webhook Subscription
  """
  @spec delete_webhook_subscription(webhook_id(), opts()) :: :ok | error()
  defdelegate delete_webhook_subscription(webhook_id, opts \\ []), to: WebhookSubscription

  @doc """
  List Webhook Subscription
  """
  @spec list_webhook_subscriptions(opts()) ::
          {:ok, [Client.WebhookSubscriptionModel.t()]} | error()
  defdelegate list_webhook_subscriptions(opts \\ []), to: WebhookSubscription

  @doc """
  Renew Webhook Subscription
  """
  @spec renew_webhook_subscription(webhook_id(), opts()) ::
          {:ok, Client.WebhookSubscriptionModel.t()} | error()
  defdelegate renew_webhook_subscription(webhook_id, opts \\ []), to: WebhookSubscription

  @doc """
  Multiple Tag (Deprecated)

  Note: This endpoint is deprecated. Use Enhanced Tags instead.
  """
  @spec multiple_tag(
          start_date(),
          end_date(),
          next_token(),
          opts()
        ) :: {:ok, Client.MultiDocumentResponseTagModel.t()} | error()
  defdelegate multiple_tag(
                start_date,
                end_date,
                next_token \\ nil,
                opts \\ []
              ),
              to: Tag

  @doc """
  Single Tag (Deprecated)

  Note: This endpoint is deprecated. Use Enhanced Tags instead.
  """
  @spec single_tag(document_id(), opts()) ::
          {:ok, Client.TagModel.t()} | error()
  defdelegate single_tag(document_id, opts \\ []), to: Tag

  @doc """
  Update Webhook Subscription
  """
  @spec update_webhook_subscription(webhook_id(), webhook(), opts()) ::
          {:ok, Client.WebhookSubscriptionModel.t()} | error()
  defdelegate update_webhook_subscription(webhook_id, webhook, opts \\ []),
    to: WebhookSubscription

  # Pagination Helper Functions

  @doc """
  Fetches all daily activity data across all pages for the given date range.

  This is a convenience function that automatically handles pagination
  using the Pagination module.

  ## Examples

      iex> ExOura.all_daily_activity(~D[2025-01-01], ~D[2025-01-31])
      {:ok, [%{id: "activity_1", ...}, %{id: "activity_2", ...}]}
  """
  @spec all_daily_activity(start_date(), end_date(), opts()) ::
          {:ok, list()} | error()
  def all_daily_activity(start_date, end_date, opts \\ []) do
    fetch_fn = &multiple_daily_activity/4
    Pagination.fetch_all_pages(fetch_fn, start_date, end_date, opts)
  end

  @doc """
  Fetches all daily readiness data across all pages for the given date range.
  """
  @spec all_daily_readiness(start_date(), end_date(), opts()) ::
          {:ok, list()} | error()
  def all_daily_readiness(start_date, end_date, opts \\ []) do
    fetch_fn = &multiple_daily_readiness/4
    Pagination.fetch_all_pages(fetch_fn, start_date, end_date, opts)
  end

  @doc """
  Fetches all daily sleep data across all pages for the given date range.
  """
  @spec all_daily_sleep(start_date(), end_date(), opts()) ::
          {:ok, list()} | error()
  def all_daily_sleep(start_date, end_date, opts \\ []) do
    fetch_fn = &multiple_daily_sleep/4
    Pagination.fetch_all_pages(fetch_fn, start_date, end_date, opts)
  end

  @doc """
  Fetches all workout data across all pages for the given date range.
  """
  @spec all_workouts(start_date(), end_date(), opts()) ::
          {:ok, list()} | error()
  def all_workouts(start_date, end_date, opts \\ []) do
    fetch_fn = &multiple_workout/4
    Pagination.fetch_all_pages(fetch_fn, start_date, end_date, opts)
  end

  @doc """
  Fetches all sleep data across all pages for the given date range.
  """
  @spec all_sleep(start_date(), end_date(), opts()) ::
          {:ok, list()} | error()
  def all_sleep(start_date, end_date, opts \\ []) do
    fetch_fn = &multiple_sleep/4
    Pagination.fetch_all_pages(fetch_fn, start_date, end_date, opts)
  end

  @doc """
  Returns a stream of all daily activity data for the given date range.

  This is memory-efficient for processing large datasets as it streams
  data page by page rather than loading everything into memory at once.

  ## Examples

      iex> ExOura.stream_daily_activity(~D[2025-01-01], ~D[2025-01-31])
      ...> |> Stream.filter(& &1.score > 80)
      ...> |> Enum.take(10)
  """
  @spec stream_daily_activity(start_date(), end_date(), opts()) :: Enumerable.t()
  def stream_daily_activity(start_date, end_date, opts \\ []) do
    fetch_fn = &multiple_daily_activity/4
    Pagination.stream_all_pages(fetch_fn, start_date, end_date, opts)
  end

  @doc """
  Returns a stream of all workout data for the given date range.
  """
  @spec stream_workouts(start_date(), end_date(), opts()) :: Enumerable.t()
  def stream_workouts(start_date, end_date, opts \\ []) do
    fetch_fn = &multiple_workout/4
    Pagination.stream_all_pages(fetch_fn, start_date, end_date, opts)
  end

  # OAuth2 Delegation Functions

  @doc """
  Generates the OAuth2 authorization URL to redirect users to.

  ## Examples

      authorization_url = ExOura.authorization_url()
      authorization_url = ExOura.authorization_url(scopes: ["daily", "heartrate"], state: "random_state")

  """
  defdelegate authorization_url(opts \\ []), to: OAuth2

  @doc """
  Exchanges an authorization code for access and refresh tokens.

  ## Examples

      {:ok, tokens} = ExOura.get_token("authorization_code_from_callback")

  """
  defdelegate get_token(code, opts \\ []), to: OAuth2

  @doc """
  Refreshes an access token using a refresh token.

  ## Examples

      {:ok, new_tokens} = ExOura.refresh_token(old_tokens.refresh_token)

  """
  defdelegate refresh_token(refresh_token, opts \\ []), to: OAuth2

  @doc """
  Checks if an access token is expired or will expire soon.

  ## Examples

      ExOura.token_expired?(tokens)
      ExOura.token_expired?(tokens, 3600)  # 1 hour buffer

  """
  defdelegate token_expired?(tokens, buffer_seconds \\ 300), to: OAuth2

  @doc """
  Returns all available OAuth2 scopes.

  ## Examples

      ExOura.available_scopes()
      # => ["email", "personal", "daily", "heartrate", "workout", "tag", "session", "spo2Daily"]

  """
  defdelegate available_scopes(), to: OAuth2

  @doc """
  Returns the default OAuth2 scopes used when none are specified.

  ## Examples

      ExOura.default_scopes()
      # => ["personal", "daily"]

  """
  defdelegate default_scopes(), to: OAuth2
end
