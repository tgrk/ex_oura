defmodule ExOura.DailyActivityTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.DailyActivityModel
  alias ExOura.Client.MultiDocumentResponseDailyActivityModel

  describe "Daily Activity" do
    test "should return multiple daily activities" do
      use_cassette "multiple_daily_activity" do
        assert {:ok,
                %MultiDocumentResponseDailyActivityModel{
                  data: [
                    %DailyActivityModel{
                      active_calories: 1_153,
                      average_met_minutes: 1.875,
                      class_5_min: _class_5_min,
                      contributors: %ExOura.Client.ActivityContributors{
                        meet_daily_targets: 100,
                        move_every_hour: 100,
                        recovery_time: 100,
                        stay_active: 65,
                        training_frequency: 100,
                        training_volume: 100
                      },
                      day: ~D[2024-11-11],
                      equivalent_walking_distance: 17_850,
                      high_activity_met_minutes: 417,
                      high_activity_time: 2_460,
                      id: "3e8de08b-9fa1-4fb0-8edc-0ccf097f6693",
                      inactivity_alerts: 0,
                      low_activity_met_minutes: 181,
                      low_activity_time: 18_060,
                      medium_activity_met_minutes: 260,
                      medium_activity_time: 4_860,
                      met: %ExOura.Client.SampleModel{
                        timestamp: ~U[2024-11-11 03:00:00.000Z],
                        items: _items,
                        interval: 60.0
                      },
                      meters_to_target: -3_500,
                      non_wear_time: 60,
                      resting_time: 22_860,
                      score: 95,
                      sedentary_met_minutes: 13,
                      sedentary_time: 38_100,
                      steps: 15_185,
                      target_calories: 950,
                      target_meters: 17_000,
                      timestamp: ~U[2024-11-11 03:00:00Z],
                      total_calories: 3_502
                    }
                  ]
                }} = ExOura.multiple_daily_activity(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should fail when arguments for multiple daily activities are not valid" do
      use_cassette "multiple_daily_activity_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseDailyActivityModel{data: [%DailyActivityModel{} | _]}} =
                 ExOura.multiple_daily_activity(~D[0024-11-11], ~D[2024-11-12])
      end
    end

    test "should return a single daily activity" do
      use_cassette "single_daily_activity" do
        assert {:ok, %DailyActivityModel{}} =
                 ExOura.single_daily_activity("3e8de08b-9fa1-4fb0-8edc-0ccf097f6693")
      end
    end

    test "should fail when document ID for single daily activity does not exists" do
      use_cassette "single_daily_activity_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_daily_activity("not-existing")
      end
    end
  end
end
