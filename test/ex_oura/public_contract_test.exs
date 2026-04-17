defmodule ExOura.PublicContractTest do
  use ExUnit.Case, async: true

  defp spec_string(module, name, arity) do
    {:ok, specs} = Code.Typespec.fetch_specs(module)

    Enum.find_value(specs, fn
      {{^name, ^arity}, spec} -> Macro.to_string(spec)
      _other -> nil
    end)
  end

  describe "top-level facade specs" do
    test "1.29 endpoints and migrated collections expose public response types" do
      assert spec_string(ExOura, :multiple_daily_activity, 4) =~ "MultiDocumentResponsePublicDailyActivity"
      assert spec_string(ExOura, :single_daily_activity, 2) =~ "PublicDailyActivity"

      assert spec_string(ExOura, :multiple_daily_cardiovascular_age, 4) =~
               "MultiDocumentResponsePublicDailyCardiovascularAge"

      assert spec_string(ExOura, :single_daily_cardiovascular_age, 2) =~ "PublicDailyCardiovascularAge"
      assert spec_string(ExOura, :multiple_daily_readiness, 4) =~ "MultiDocumentResponsePublicDailyReadiness"
      assert spec_string(ExOura, :single_daily_readiness, 2) =~ "PublicDailyReadiness"
      assert spec_string(ExOura, :multiple_daily_sleep, 4) =~ "MultiDocumentResponsePublicDailySleep"
      assert spec_string(ExOura, :single_daily_sleep, 2) =~ "PublicDailySleep"
      assert spec_string(ExOura, :multiple_daily_sp02, 4) =~ "MultiDocumentResponsePublicDailySpO2"
      assert spec_string(ExOura, :single_daily_sp02, 2) =~ "PublicDailySpO2"
      assert spec_string(ExOura, :multiple_daily_stress, 4) =~ "MultiDocumentResponsePublicDailyStress"
      assert spec_string(ExOura, :single_daily_stress, 2) =~ "PublicDailyStress"
      assert spec_string(ExOura, :multiple_heart_rate, 4) =~ "TimeSeriesResponsePublicHeartRateRow"
      assert spec_string(ExOura, :multiple_interbeat_interval, 4) =~ "TimeSeriesResponsePublicInterbeatIntervalRow"
      assert spec_string(ExOura, :multiple_ring_battery_level, 4) =~ "TimeSeriesResponsePublicRingBatteryLevelRow"

      assert spec_string(ExOura, :multiple_rest_mode_period, 4) =~
               "MultiDocumentResponsePublicRestModePeriod"

      assert spec_string(ExOura, :single_rest_mode_period, 2) =~ "PublicRestModePeriod"

      assert spec_string(ExOura, :multiple_ring_configuration, 4) =~
               "MultiDocumentResponsePublicRingConfiguration"

      assert spec_string(ExOura, :single_ring_configuration, 2) =~ "PublicRingConfiguration"
      assert spec_string(ExOura, :multiple_session, 4) =~ "MultiDocumentResponsePublicSession"
      assert spec_string(ExOura, :single_session, 2) =~ "PublicSession"

      assert spec_string(ExOura, :multiple_sleep, 4) =~
               "MultiDocumentResponsePublicModifiedSleepModel"

      assert spec_string(ExOura, :single_sleep, 2) =~ "PublicModifiedSleepModel"
      assert spec_string(ExOura, :multiple_sleep_time, 4) =~ "MultiDocumentResponsePublicSleepTime"
      assert spec_string(ExOura, :single_sleep_time, 2) =~ "PublicSleepTime"
      assert spec_string(ExOura, :multiple_vo2_max, 4) =~ "MultiDocumentResponsePublicVo2Max"
      assert spec_string(ExOura, :single_vo2_max, 2) =~ "PublicVo2Max"
      assert spec_string(ExOura, :multiple_workout, 4) =~ "MultiDocumentResponsePublicWorkout"
      assert spec_string(ExOura, :single_workout, 2) =~ "PublicWorkout"
    end
  end

  describe "wrapper-local types" do
    test "handwritten wrappers point to the same public response modules" do
      assert spec_string(ExOura.DailyActivity, :multiple_daily_activity, 4) =~ "activity_response"

      assert spec_string(ExOura.RingConfiguration, :multiple_ring_configuration, 4) =~
               "public_ring_configuration_response"

      assert spec_string(ExOura.Session, :multiple_session, 4) =~ "session_response"
      assert spec_string(ExOura.Sleep, :multiple_sleep, 4) =~ "sleep_response"
      assert spec_string(ExOura.SleepTime, :multiple_sleep_time, 4) =~ "sleep_time_response"
      assert spec_string(ExOura.Vo2Max, :multiple_vo2_max, 4) =~ "vo2_max_response"
      assert spec_string(ExOura.Workout, :multiple_workout, 4) =~ "workout_response"
    end
  end
end
