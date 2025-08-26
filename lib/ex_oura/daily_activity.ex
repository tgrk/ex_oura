defmodule ExOura.DailyActivity do
  @moduledoc """
  API functions for retrieving Oura daily activity data.

  Daily activity data includes metrics such as active calories, steps, equivalent walking distance,
  total calories, target calories, activity score, and activity contributors. This data represents
  a user's comprehensive daily movement and activity patterns.

  ## Data Availability

  Daily activity data is typically available for the previous day by around 10-12 AM UTC.
  Historical data can be retrieved for up to 2 years.

  ## Common Use Cases

  - Tracking daily step counts and activity levels
  - Monitoring calorie burn and activity goals
  - Analyzing activity patterns over time
  - Building fitness dashboards and reports

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
  @type activity_response :: {:ok, Client.MultiDocumentResponseDailyActivityModel.t()} | {:error, term()}
  @type single_activity_response :: {:ok, Client.DailyActivityModel.t()} | {:error, term()}

  @doc """
  Retrieves multiple daily activity records for a specified date range.

  Returns paginated daily activity data. If the date range contains more data than can be returned
  in a single response, a `next_token` will be included in the response that can be used to fetch
  the next page of results.

  ## Parameters

  - `start_date` - The start date for the data range (Date struct, inclusive)
  - `end_date` - The end date for the data range (Date struct, inclusive)
  - `next_token` - Optional token for pagination (from previous response)
  - `opts` - Optional keyword list of additional parameters

  ## Options

  - `:timeout` - Request timeout in milliseconds (defaults to configured timeout)

  ## Returns

  - `{:ok, response}` - Success with activity data and optional next_token
  - `{:error, reason}` - Error with details about what went wrong

  ## Examples

      # Get activity data for January 2025
      {:ok, activities} = ExOura.DailyActivity.multiple_daily_activity(
        ~D[2025-01-01],
        ~D[2025-01-31]
      )

      # Access the activity data
      activities.data
      |> Enum.each(fn activity ->
        IO.puts("Steps: \#{activity.steps}, Score: \#{activity.score}")
      end)

      # Handle pagination
      {:ok, page1} = ExOura.DailyActivity.multiple_daily_activity(
        ~D[2025-01-01],
        ~D[2025-12-31]
      )

      case page1.next_token do
        nil ->
          IO.puts("All data retrieved")
        token ->
          {:ok, page2} = ExOura.DailyActivity.multiple_daily_activity(
            ~D[2025-01-01],
            ~D[2025-12-31],
            token
          )
      end

  ## Response Structure

  The response contains:
  - `data` - List of daily activity records
  - `next_token` - Token for next page (nil if no more data)

  Each activity record includes:
  - `id` - Unique identifier
  - `day` - Date of the activity (YYYY-MM-DD)
  - `score` - Overall activity score (0-100)
  - `active_calories` - Active calories burned
  - `steps` - Step count
  - `equivalent_walking_distance` - Distance in meters
  - `total_calories` - Total calories burned
  - `target_calories` - Target calorie goal
  - `contributors` - Breakdown of score contributors
  - `timestamp` - When the data was recorded
  """
  @spec multiple_daily_activity(start_date(), end_date(), next_token(), opts()) :: activity_response()
  def multiple_daily_activity(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.DailyActivityRoutes,
      :multiple_daily_activity_documents_v2_usercollection_daily_activity_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Retrieves a single daily activity record by its document ID.

  Use this function when you need to fetch a specific activity record by its unique identifier.
  This is useful for retrieving detailed information about a particular day's activity.

  ## Parameters

  - `document_id` - The unique identifier for the daily activity document
  - `opts` - Optional keyword list of additional parameters

  ## Options

  - `:timeout` - Request timeout in milliseconds (defaults to configured timeout)

  ## Returns

  - `{:ok, activity}` - Success with single activity record
  - `{:error, reason}` - Error with details (e.g., document not found)

  ## Examples

      # Get a specific activity record
      {:ok, activity} = ExOura.DailyActivity.single_daily_activity("daily_activity_2025-01-15")

      IO.puts("Activity Score: \#{activity.score}")
      IO.puts("Steps: \#{activity.steps}")
      IO.puts("Active Calories: \#{activity.active_calories}")

      # Handle errors
      case ExOura.DailyActivity.single_daily_activity("invalid_id") do
        {:ok, activity} ->
          process_activity(activity)
        {:error, reason} ->
          IO.puts("Failed to fetch activity: \#{inspect(reason)}")
      end

  ## Response Structure

  Returns a single activity record with the same structure as described in
  `multiple_daily_activity/4`, but without the pagination wrapper.
  """
  @spec single_daily_activity(document_id(), opts()) :: single_activity_response()
  def single_daily_activity(document_id, opts \\ []) do
    Client.call_api(
      Client.DailyActivityRoutes,
      :single_daily_activity_document_v2_usercollection_daily_activity_document_id_get,
      document_id,
      opts
    )
  end
end
