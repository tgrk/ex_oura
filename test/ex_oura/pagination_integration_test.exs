defmodule ExOura.PaginationIntegrationTest do
  use ExUnit.Case, async: true

  setup do
    # Start the client with a test token for integration tests
    # Handle case where client is already started
    case ExOura.Client.start_link("test_access_token") do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :ok
    end
  end

  describe "pagination convenience functions" do
    @tag :skip
    test "all_daily_activity/3 fetches all pages" do
      # This test would require real API responses or better mocking
      # For now, we'll test the function exists and has correct type specs

      _start_date = ~D[2025-01-01]
      _end_date = ~D[2025-01-02]

      # This would fail without proper API setup, so we skip it
      # but demonstrate the intended usage
      assert function_exported?(ExOura, :all_daily_activity, 3)
    end

    test "convenience functions are properly exported" do
      # Verify all our new pagination functions are properly exported
      exported_functions = ExOura.__info__(:functions)

      assert {:all_daily_activity, 3} in exported_functions
      assert {:all_daily_readiness, 3} in exported_functions
      assert {:all_daily_sleep, 3} in exported_functions
      assert {:all_workouts, 3} in exported_functions
      assert {:all_sleep, 3} in exported_functions
      assert {:stream_daily_activity, 3} in exported_functions
      assert {:stream_workouts, 3} in exported_functions
    end

    test "convenience functions handle empty date ranges gracefully" do
      # Create a mock that returns empty data
      mock_fetch_fn = fn _start_date, _end_date, _next_token, _opts ->
        {:ok, %{data: [], next_token: nil}}
      end

      # Test with mock function directly to verify integration
      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-02]

      {:ok, result} =
        ExOura.Pagination.fetch_all_pages(
          mock_fetch_fn,
          start_date,
          end_date
        )

      assert result == []
    end
  end

  describe "stream functions" do
    test "stream functions return Stream objects" do
      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-02]

      # These should return Stream objects even if they fail when enumerated
      activity_stream = ExOura.stream_daily_activity(start_date, end_date)
      workout_stream = ExOura.stream_workouts(start_date, end_date)

      # Check that they are indeed streams by verifying they implement the Stream protocol
      assert is_function(activity_stream, 2)
      assert is_function(workout_stream, 2)

      # Also verify they behave like streams by checking they are lazy
      assert activity_stream |> Stream.take(0) |> Enum.to_list() == []
      assert workout_stream |> Stream.take(0) |> Enum.to_list() == []
    end
  end
end
