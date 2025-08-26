defmodule ExOura.DailySleep do
  @moduledoc """
  API functions for retrieving Oura daily sleep data.

  Daily sleep data provides comprehensive sleep metrics including sleep score, sleep duration,
  bedtime and wake-up times, sleep efficiency, time in different sleep stages, and various
  sleep quality indicators. This data represents the user's sleep patterns and quality.

  ## Data Availability

  Daily sleep data is typically available by around 10 AM local time for the previous night.
  Historical data can be retrieved for up to 2 years.

  ## Sleep Metrics Included

  - Sleep score (0-100)
  - Total sleep time and time in bed
  - Sleep efficiency percentage
  - Time spent in different sleep stages (deep, light, REM, awake)
  - Sleep latency (time to fall asleep)
  - Bedtime and wake-up times
  - Heart rate variability during sleep
  - Respiratory rate
  - Sleep contributors (factors affecting sleep quality)

  ## Common Use Cases

  - Sleep quality tracking and optimization
  - Sleep pattern analysis
  - Building sleep dashboards and reports
  - Correlating sleep with other health metrics

  ## Rate Limits

  All endpoints are subject to the standard Oura API rate limits:
  - 5000 requests per day
  - 300 requests per minute
  """

  alias ExOura.Client

  @type start_date :: Date.t()
  @type end_date :: Date.t()
  @type next_token :: String.t() | nil
  @type document_id :: String.t()
  @type opts :: Keyword.t()
  @type sleep_response :: {:ok, Client.MultiDocumentResponseDailySleepModel.t()} | {:error, term()}
  @type single_sleep_response :: {:ok, Client.DailySleepModel.t()} | {:error, term()}

  @doc """
  Retrieves multiple daily sleep records for a specified date range.

  Returns paginated daily sleep data. If the date range contains more data than can be returned
  in a single response, a `next_token` will be included in the response for fetching subsequent pages.

  ## Parameters

  - `start_date` - The start date for the data range (Date struct, inclusive)
  - `end_date` - The end date for the data range (Date struct, inclusive)
  - `next_token` - Optional token for pagination (from previous response)
  - `opts` - Optional keyword list of additional parameters

  ## Options

  - `:timeout` - Request timeout in milliseconds (defaults to configured timeout)

  ## Returns

  - `{:ok, response}` - Success with sleep data and optional next_token
  - `{:error, reason}` - Error with details about what went wrong

  ## Examples

      # Get sleep data for January 2025
      {:ok, sleep_data} = ExOura.DailySleep.multiple_daily_sleep(
        ~D[2025-01-01],
        ~D[2025-01-31]
      )

      # Access sleep metrics
      sleep_data.data
      |> Enum.each(fn sleep ->
        IO.puts("Sleep Score: \#{sleep.score}")
        IO.puts("Total Sleep: \#{sleep.total_sleep_duration} minutes")
        IO.puts("Sleep Efficiency: \#{sleep.efficiency}%")
      end)

      # Handle pagination for larger date ranges
      {:ok, page1} = ExOura.DailySleep.multiple_daily_sleep(
        ~D[2024-01-01],
        ~D[2024-12-31]
      )

      if page1.next_token do
        {:ok, page2} = ExOura.DailySleep.multiple_daily_sleep(
          ~D[2024-01-01],
          ~D[2024-12-31],
          page1.next_token
        )
      end

  ## Response Structure

  The response contains:
  - `data` - List of daily sleep records
  - `next_token` - Token for next page (nil if no more data)

  Each sleep record includes comprehensive sleep metrics such as:
  - `id` - Unique identifier
  - `day` - Date of the sleep session (YYYY-MM-DD)
  - `score` - Overall sleep score (0-100)
  - `total_sleep_duration` - Total sleep time in minutes
  - `efficiency` - Sleep efficiency percentage
  - `bedtime_start` - When the user went to bed
  - `bedtime_end` - When the user woke up
  - `deep_sleep_duration` - Time in deep sleep (minutes)
  - `light_sleep_duration` - Time in light sleep (minutes)
  - `rem_sleep_duration` - Time in REM sleep (minutes)
  - `awake_duration` - Time awake in bed (minutes)
  - `contributors` - Factors affecting sleep score
  """
  @spec multiple_daily_sleep(start_date(), end_date(), next_token(), opts()) :: sleep_response()
  def multiple_daily_sleep(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.DailySleepRoutes,
      :multiple_daily_sleep_documents_v2_usercollection_daily_sleep_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Retrieves a single daily sleep record by its document ID.

  Use this function when you need to fetch detailed sleep information for a specific night.
  This is useful for getting comprehensive sleep metrics for a particular sleep session.

  ## Parameters

  - `document_id` - The unique identifier for the daily sleep document
  - `opts` - Optional keyword list of additional parameters

  ## Options

  - `:timeout` - Request timeout in milliseconds (defaults to configured timeout)

  ## Returns

  - `{:ok, sleep}` - Success with single sleep record
  - `{:error, reason}` - Error with details (e.g., document not found)

  ## Examples

      # Get a specific sleep record
      {:ok, sleep} = ExOura.DailySleep.single_daily_sleep("daily_sleep_2025-01-15")

      IO.puts("Sleep Score: \#{sleep.score}")
      IO.puts("Total Sleep: \#{sleep.total_sleep_duration} minutes")
      IO.puts("Deep Sleep: \#{sleep.deep_sleep_duration} minutes")
      IO.puts("REM Sleep: \#{sleep.rem_sleep_duration} minutes")

      # Analyze sleep quality
      case ExOura.DailySleep.single_daily_sleep("daily_sleep_2025-01-15") do
        {:ok, sleep} when sleep.score >= 80 ->
          IO.puts("Great night's sleep!")
        {:ok, sleep} ->
          IO.puts("Sleep score: \#{sleep.score} - room for improvement")
        {:error, reason} ->
          IO.puts("Error fetching sleep data: \#{inspect(reason)}")
      end

  ## Response Structure

  Returns a single sleep record with the same comprehensive metrics as described in
  `multiple_daily_sleep/4`, but without the pagination wrapper.

  ## Sleep Stage Analysis

  The response includes detailed sleep stage information:
  - Deep sleep: Most restorative sleep phase
  - Light sleep: Transitional sleep phase
  - REM sleep: Associated with dreaming and memory consolidation
  - Awake time: Time spent awake while in bed
  """
  @spec single_daily_sleep(document_id(), opts()) :: single_sleep_response()
  def single_daily_sleep(document_id, opts \\ []) do
    Client.call_api(
      Client.DailySleepRoutes,
      :single_daily_sleep_document_v2_usercollection_daily_sleep_document_id_get,
      document_id,
      opts
    )
  end
end
