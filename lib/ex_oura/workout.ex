defmodule ExOura.Workout do
  @moduledoc """
  API functions for retrieving Oura workout data.

  Workout data includes both auto-detected workouts and manually entered workout sessions.
  This data provides workout summary information including activity, timestamps, intensity,
  calories, distance, source, and optional labels.

  ## Workout Types

  The Oura Ring can detect various types of workouts:
  - **Auto-detected**: Walking, running, cycling, and other activities automatically recognized
  - **Manual entries**: Workouts manually logged by the user in the Oura app
  - **Heart rate based**: Workouts identified through elevated heart rate patterns

  ## Data Availability

  Workout data is available shortly after the workout session ends. Historical workout
  data can be retrieved for up to 2 years.

  ## Workout Summary Fields

  Each workout record includes:
  - Activity type and source (auto-detected vs manual)
  - Start and end timestamps
  - Intensity classification
  - Calories burned
  - Optional distance and label
  - Oura metadata for the workout document

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
  @type workout_response :: {:ok, Client.MultiDocumentResponsePublicWorkout.t()} | {:error, term()}
  @type single_workout_response :: {:ok, Client.PublicWorkout.t()} | {:error, term()}

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
        total_calories = workouts |> Enum.map(&(&1.calories || 0)) |> Enum.sum()
        IO.puts("\#{activity_type}: \#{count} workouts, \#{total_calories} total calories")
      end)

      # Filter labeled workouts
      labeled_workouts =
        workouts.data
        |> Enum.filter(&is_binary(&1.label))

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
  - `intensity` - Intensity level ("easy", "moderate", "hard")
  - `calories` - Calories burned during the workout
  - `distance` - Distance in meters when available
  - `label` - Optional user-visible workout label
  - `meta` - Oura metadata for the workout document
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
      IO.puts("Start: \#{workout.start_datetime}")
      IO.puts("Calories: \#{workout.calories}")
      IO.puts("Distance: \#{workout.distance}")

      # Check whether the workout has a label
      case ExOura.Workout.single_workout("workout_id") do
        {:ok, workout} ->
          if workout.label do
            IO.puts("Label: \#{workout.label}")
          end

        {:error, reason} ->
          IO.puts("Error: \#{inspect(reason)}")
      end

      # Check workout source and intensity
      {:ok, workout} = ExOura.Workout.single_workout("workout_id")

      case {workout.source, workout.intensity} do
        {"autodetected", "hard"} ->
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
  - `distance` and `calories` are the main quantitative workout fields in this model
  - `label` can help distinguish user-curated sessions from generic activity names
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
