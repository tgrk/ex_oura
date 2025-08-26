defmodule ExOura.Workout do
  @moduledoc """
  API functions for retrieving Oura workout data.

  Workout data includes both auto-detected workouts and manually entered workout sessions.
  This data provides detailed information about exercise sessions including duration, intensity,
  calories burned, heart rate zones, and workout-specific metrics.

  ## Workout Types

  The Oura Ring can detect various types of workouts:
  - **Auto-detected**: Walking, running, cycling, and other activities automatically recognized
  - **Manual entries**: Workouts manually logged by the user in the Oura app
  - **Heart rate based**: Workouts identified through elevated heart rate patterns

  ## Data Availability

  Workout data is available shortly after the workout session ends. Historical workout
  data can be retrieved for up to 2 years.

  ## Workout Metrics

  Each workout record includes:
  - Activity type and source (auto-detected vs manual)
  - Start and end times
  - Duration and intensity
  - Calories burned
  - Average and maximum heart rate
  - Time in different heart rate zones
  - Motion count and intensity patterns

  ## Common Use Cases

  - Exercise tracking and performance analysis
  - Workout pattern identification
  - Integration with fitness applications
  - Building comprehensive health dashboards
  - Correlating workouts with recovery metrics

  ## OAuth2 Scope Required

  Requires the "workout" scope to access workout data.

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
  @type workout_response :: {:ok, Client.MultiDocumentResponseWorkoutModel.t()} | {:error, term()}
  @type single_workout_response :: {:ok, Client.WorkoutModel.t()} | {:error, term()}

  @doc """
  Retrieves multiple workout records for a specified date range.

  Returns paginated workout data including both auto-detected and manually logged workouts.
  This endpoint is essential for comprehensive exercise and activity tracking.

  ## Parameters

  - `start_date` - The start date for the data range (Date struct, inclusive)
  - `end_date` - The end date for the data range (Date struct, inclusive)
  - `next_token` - Optional token for pagination (from previous response)
  - `opts` - Optional keyword list of additional parameters

  ## Options

  - `:timeout` - Request timeout in milliseconds (defaults to configured timeout)

  ## Returns

  - `{:ok, response}` - Success with workout data and optional next_token
  - `{:error, reason}` - Error with details about what went wrong

  ## Examples

      # Get workouts for January 2025
      {:ok, workouts} = ExOura.Workout.multiple_workout(
        ~D[2025-01-01],
        ~D[2025-01-31]
      )

      # Analyze workout patterns
      workouts.data
      |> Enum.group_by(& &1.activity)
      |> Enum.each(fn {activity_type, workouts} ->
        count = length(workouts)
        avg_duration = workouts |> Enum.map(& &1.duration) |> Enum.sum() |> div(count)
        IO.puts("\#{activity_type}: \#{count} workouts, avg duration: \#{avg_duration}s")
      end)

      # Filter high-intensity workouts
      high_intensity_workouts = workouts.data
      |> Enum.filter(fn workout ->
        workout.intensity == "high" or
        (workout.average_heart_rate && workout.average_heart_rate > 150)
      end)

      # Handle pagination for large date ranges
      {:ok, page1} = ExOura.Workout.multiple_workout(
        ~D[2024-01-01],
        ~D[2024-12-31]
      )

      if page1.next_token do
        {:ok, page2} = ExOura.Workout.multiple_workout(
          ~D[2024-01-01],
          ~D[2024-12-31],
          page1.next_token
        )
      end

  ## Response Structure

  The response contains:
  - `data` - List of workout records
  - `next_token` - Token for next page (nil if no more data)

  Each workout record includes:
  - `id` - Unique workout identifier
  - `activity` - Type of activity (e.g., "walking", "running", "cycling")
  - `source` - How the workout was detected ("autodetected", "manual", "confirmed")
  - `day` - Date of the workout (YYYY-MM-DD)
  - `start_datetime` - When the workout started
  - `end_datetime` - When the workout ended
  - `duration` - Workout duration in seconds
  - `intensity` - Intensity level ("low", "medium", "high")
  - `calories` - Calories burned during the workout
  - `average_heart_rate` - Average heart rate (if available)
  - `maximum_heart_rate` - Peak heart rate (if available)
  - `heart_rate_zones` - Time spent in different HR zones
  - `motion_count` - Movement intensity data
  """
  @spec multiple_workout(start_date(), end_date(), next_token(), opts()) :: workout_response()
  def multiple_workout(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.WorkoutRoutes,
      :multiple_workout_documents_v2_usercollection_workout_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Retrieves a single workout record by its document ID.

  Use this function when you need detailed information about a specific workout session.
  This is useful for in-depth analysis of individual exercise sessions.

  ## Parameters

  - `document_id` - The unique identifier for the workout document
  - `opts` - Optional keyword list of additional parameters

  ## Options

  - `:timeout` - Request timeout in milliseconds (defaults to configured timeout)

  ## Returns

  - `{:ok, workout}` - Success with single workout record
  - `{:error, reason}` - Error with details (e.g., document not found)

  ## Examples

      # Get detailed workout information
      {:ok, workout} = ExOura.Workout.single_workout("workout_2025-01-15T14-30-00")

      IO.puts("Activity: \#{workout.activity}")
      IO.puts("Duration: \#{workout.duration} seconds")
      IO.puts("Calories: \#{workout.calories}")
      IO.puts("Average HR: \#{workout.average_heart_rate} bpm")

      # Analyze heart rate zones
      case ExOura.Workout.single_workout("workout_id") do
        {:ok, workout} ->
          if workout.heart_rate_zones do
            IO.puts("Time in zones: \#{inspect(workout.heart_rate_zones)}")
          end
        {:error, reason} ->
          IO.puts("Error: \#{inspect(reason)}")
      end

      # Check workout source and intensity
      {:ok, workout} = ExOura.Workout.single_workout("workout_id")

      case {workout.source, workout.intensity} do
        {"autodetected", "high"} ->
          IO.puts("High-intensity workout automatically detected")
        {"manual", _} ->
          IO.puts("Manually logged workout")
        _ ->
          IO.puts("Regular detected workout")
      end

  ## Response Structure

  Returns a single workout record with the same comprehensive metrics as described in
  `multiple_workout/4`, but without the pagination wrapper.

  ## Workout Analysis Tips

  - Use `source` to distinguish between auto-detected and manual workouts
  - `intensity` provides a quick assessment of workout difficulty
  - Heart rate data (when available) offers detailed cardiovascular insights
  - Motion count can indicate movement patterns and workout variability
  """
  @spec single_workout(document_id(), opts()) :: single_workout_response()
  def single_workout(document_id, opts \\ []) do
    Client.call_api(
      Client.WorkoutRoutes,
      :single_workout_document_v2_usercollection_workout_document_id_get,
      document_id,
      opts
    )
  end
end
