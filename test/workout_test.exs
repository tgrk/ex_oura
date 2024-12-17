defmodule ExOura.WorkoutTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponseWorkoutModel
  alias ExOura.Client.WorkoutModel

  describe "Workout" do
    test "should return multiple workouts" do
      use_cassette "multiple_workout" do
        assert {:ok,
                %MultiDocumentResponseWorkoutModel{
                  data: [
                    %ExOura.Client.WorkoutModel{
                      activity: "walking",
                      calories: 21.967,
                      day: ~D[2024-10-09],
                      distance: nil,
                      end_datetime: "2024-10-09T09:18:00+02:00",
                      id: "23264206-4a83-4619-abff-0e77bf6cd562",
                      intensity: "easy",
                      label: nil,
                      source: "confirmed",
                      start_datetime: "2024-10-09T09:07:00+02:00"
                    }
                    | _
                  ]
                }} = ExOura.multiple_workout(~D[2024-10-09], ~D[2024-11-03])
      end
    end

    test "should fail when arguments for multiple workouts are not valid" do
      use_cassette "multiple_workout_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseWorkoutModel{data: []}} =
                 ExOura.multiple_workout(1, 2)
      end
    end

    test "should return a single workout" do
      use_cassette "single_workout" do
        assert {:ok, %WorkoutModel{}} =
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
end
