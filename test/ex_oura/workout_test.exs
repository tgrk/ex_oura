defmodule ExOura.WorkoutTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponsePublicWorkout
  alias ExOura.Client.PublicWorkout

  describe "Workout" do
    test "should return multiple workouts" do
      use_cassette "multiple_workout" do
        assert {:ok,
                %MultiDocumentResponsePublicWorkout{
                  data: [
                    %PublicWorkout{
                      activity: "walking",
                      calories: 21.967,
                      day: ~D[2024-10-09],
                      distance: nil,
                      end_datetime: ~U[2024-10-09 07:18:00Z],
                      id: "23264206-4a83-4619-abff-0e77bf6cd562",
                      intensity: "easy",
                      label: nil,
                      source: "confirmed",
                      start_datetime: ~U[2024-10-09 07:07:00Z]
                    }
                    | _
                  ]
                }} = ExOura.multiple_workout(~D[2024-10-09], ~D[2024-11-03])
      end
    end

    test "should fail when arguments for multiple workouts are not valid" do
      assert {:error, :invalid_start_date} = ExOura.multiple_workout(1, 2)
    end

    test "should return a single workout" do
      use_cassette "single_workout" do
        assert {:ok, %PublicWorkout{}} =
                 ExOura.single_workout("23264206-4a83-4619-abff-0e77bf6cd562")
      end
    end

    test "should fail when document ID for single workout does not exists" do
      use_cassette "single_workout_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_workout("not-existing")
      end
    end
  end

  describe "PublicWorkout Model" do
    test "should have correct field definitions" do
      expected_fields = [
        activity: {:string, :generic},
        calories: {:union, [:number, :null]},
        day: {:string, :generic},
        distance: {:union, [:number, :null]},
        end_datetime: {:string, :generic},
        id: {:string, :generic},
        intensity: {:enum, ["easy", "moderate", "hard"]},
        label: {:union, [{:string, :generic}, :null]},
        source: {:enum, ["manual", "autodetected", "confirmed", "workout_heart_rate"]},
        start_datetime: {:string, :generic}
      ]

      assert PublicWorkout.__fields__(:t) == expected_fields
      # Test default parameter
      assert PublicWorkout.__fields__() == expected_fields
    end

    test "should create struct with all fields" do
      workout = %PublicWorkout{
        activity: "running",
        calories: 300.5,
        day: "2024-01-15",
        distance: 5000,
        end_datetime: "2024-01-15T08:30:00Z",
        id: "workout-id-123",
        intensity: "moderate",
        label: "Morning run",
        source: "manual",
        start_datetime: "2024-01-15T08:00:00Z"
      }

      assert workout.activity == "running"
      assert workout.calories == 300.5
      assert workout.intensity == "moderate"
    end
  end
end
