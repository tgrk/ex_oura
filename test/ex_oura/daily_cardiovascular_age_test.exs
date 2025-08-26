defmodule ExOura.DailyCardiovascularAgeTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.DailyCardiovascularAgeModel
  alias ExOura.Client.MultiDocumentResponseDailyCardiovascularAgeModel

  describe "Daily Cardiovascular Age" do
    test "should return multiple daily cardiovascular age" do
      use_cassette "multiple_daily_cardiovascular_age" do
        assert {:ok, %MultiDocumentResponseDailyCardiovascularAgeModel{data: [_ | _]}} =
                 ExOura.multiple_daily_cardiovascular_age(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should return multiple daily cardiovascular age with next_token" do
      use_cassette "multiple_daily_cardiovascular_age_with_token" do
        assert {:ok, %MultiDocumentResponseDailyCardiovascularAgeModel{data: [_ | _]}} =
                 ExOura.multiple_daily_cardiovascular_age(~D[2024-11-11], ~D[2024-11-12], "token123")
      end
    end

    test "should fail when arguments for multiple daily cardiovascular age are not valid" do
      assert {:error, :invalid_end_date} =
               ExOura.multiple_daily_cardiovascular_age(~D[0024-11-11], ~S[2024-11-12])
    end

    test "Daily Cardiovascular Age should fail when date range is invalid" do
      use_cassette "daily_cardiovascular_age_invalid_date_range" do
        assert {:error, :end_date_before_start_date} =
                 ExOura.multiple_daily_cardiovascular_age(~D"2025-11-11", ~D"2024-11-12")
      end
    end

    test "should return a single daily cardiovascular age" do
      use_cassette "single_daily_cardiovascular_age" do
        assert {:ok, %DailyCardiovascularAgeModel{}} =
                 ExOura.single_daily_cardiovascular_age("cardio-age-id-123")
      end
    end

    test "should fail when document ID for single daily cardiovascular age does not exist" do
      use_cassette "single_daily_cardiovascular_age_not_found" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_daily_cardiovascular_age("non-existing-id")
      end
    end

    test "should handle malformed document ID" do
      use_cassette "single_daily_cardiovascular_age_malformed" do
        assert {:error, %{detail: _message}} =
                 ExOura.single_daily_cardiovascular_age("malformed-id")
      end
    end
  end
end
