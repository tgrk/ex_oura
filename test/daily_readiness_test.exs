defmodule ExOura.DailyReadinessTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.DailyReadinessModel
  alias ExOura.Client.MultiDocumentResponseDailyReadinessModel
  alias ExOura.DailyReadiness

  describe "Daily Readiness" do
    test "should return multiple daily readiness" do
      use_cassette "multiple_daily_readiness" do
        assert {:ok, %MultiDocumentResponseDailyReadinessModel{data: [_ | _]}} =
                 DailyReadiness.multiple_daily_readiness(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should fail when arguments for multiple daily readiness are not valid" do
      use_cassette "multiple_daily_readiness_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseDailyReadinessModel{data: [_ | _]}} =
                 DailyReadiness.multiple_daily_readiness(~D[0024-11-11], ~D[2024-11-12])
      end
    end

    test "should return a single daily readiness" do
      use_cassette "single_daily_readiness" do
        assert {:ok, %DailyReadinessModel{}} =
                 DailyReadiness.single_daily_readiness("93b2a8ec-ccdb-49bf-84f5-d06a77873f25")
      end
    end

    test "should fail when document ID for single daily readiness does not exists" do
      use_cassette "single_daily_readiness_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 DailyReadiness.single_daily_readiness("not-existing")
      end
    end
  end
end
