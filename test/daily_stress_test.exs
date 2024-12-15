defmodule ExOura.DailyStressTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.DailyStressModel
  alias ExOura.Client.MultiDocumentResponseDailyStressModel

  describe "Daily Stress" do
    test "should return multiple daily stress" do
      use_cassette "multiple_daily_stress" do
        assert {:ok, %MultiDocumentResponseDailyStressModel{data: [_ | _]}} =
                 ExOura.multiple_daily_stress(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should fail when arguments for multiple daily activities are not valid" do
      use_cassette "multiple_daily_stress_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseDailyStressModel{data: [_ | _]}} =
                 ExOura.multiple_daily_stress(~D[0024-11-11], ~D[2024-11-12])
      end
    end

    test "should return a single daily stress" do
      use_cassette "single_daily_stress" do
        assert {:ok, %DailyStressModel{}} =
                 ExOura.single_daily_stress("7c4d1981-ad05-4f24-b2c7-9ac826936555")
      end
    end

    test "should fail when document ID for single daily stress does not exists" do
      use_cassette "single_daily_stress_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_daily_stress("not-existing")
      end
    end
  end
end
