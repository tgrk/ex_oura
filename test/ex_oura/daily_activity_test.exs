defmodule ExOura.DailyActivityTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponsePublicDailyActivity
  alias ExOura.Client.PublicDailyActivity

  describe "Daily Activity" do
    test "should return multiple daily activities" do
      use_cassette "multiple_daily_activity" do
        assert {:ok,
                %MultiDocumentResponsePublicDailyActivity{
                  data: [
                    %PublicDailyActivity{
                      active_calories: 1_153,
                      day: ~D[2024-11-11],
                      id: "3e8de08b-9fa1-4fb0-8edc-0ccf097f6693",
                      score: 95,
                      steps: 15_185,
                      meta: _meta
                    }
                  ]
                }} = ExOura.multiple_daily_activity(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should fail when arguments for multiple daily activities are not valid" do
      use_cassette "multiple_daily_activity_invalid_arguments" do
        assert {:ok, %MultiDocumentResponsePublicDailyActivity{data: [%PublicDailyActivity{} | _]}} =
                 ExOura.multiple_daily_activity(~D[0024-11-11], ~D[2024-11-12])
      end
    end

    test "should return a single daily activity" do
      use_cassette "single_daily_activity" do
        assert {:ok, %PublicDailyActivity{}} =
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
