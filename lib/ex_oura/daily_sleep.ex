defmodule ExOura.DailySleep do
  @moduledoc """
  API functions for retrieving Oura daily sleep data.

  Daily sleep data provides a compact day-level sleep summary including the sleep score,
  contributing factors, and timestamps for when the daily aggregate was produced.

  For detailed per-sleep-session metrics such as bedtime windows, sleep stages, or heart-rate
  data, use `ExOura.Sleep`.

  ## Data Availability

  Daily sleep data is typically available by around 10 AM local time for the previous night.
  Historical data can be retrieved for up to 2 years.

  ## Daily Summary Included

  - Sleep score (0-100)
  - Sleep contributors (factors affecting the score)
  - Day-level identifier and timestamp
  - Oura metadata for the aggregate document

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
  @type sleep_response :: {:ok, Client.MultiDocumentResponsePublicDailySleep.t()} | {:error, term()}
  @type single_sleep_response :: {:ok, Client.PublicDailySleep.t()} | {:error, term()}

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

      # Access daily sleep summary data
      sleep_data.data
      |> Enum.each(fn sleep ->
        IO.puts("Sleep Score: \#{sleep.score}")
        IO.puts("Day: \#{sleep.day}")
        IO.puts("Generated At: \#{sleep.timestamp}")
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

  Each daily sleep record includes:
  - `id` - Unique identifier
  - `day` - Date of the sleep session (YYYY-MM-DD)
  - `score` - Overall sleep score (0-100)
  - `contributors` - Factors affecting sleep score
  - `timestamp` - When the aggregate document was recorded
  - `meta` - Oura metadata for the aggregate document
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
  Retrieves a single daily sleep summary record by its document ID.

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
      IO.puts("Day: \#{sleep.day}")
      IO.puts("Generated At: \#{sleep.timestamp}")

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

  Returns a single daily sleep summary record with the same fields as described in
  `multiple_daily_sleep/4`, but without the pagination wrapper.
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
