defmodule ExOura.DailyResilienceTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.DailyResilienceModel
  alias ExOura.Client.MultiDocumentResponseDailyResilienceModel
  alias ExOura.DailyResilience

  describe "Daily Resilience" do
    test "should return multiple daily resilience" do
      use_cassette "multiple_daily_resilience" do
        assert {:ok, %MultiDocumentResponseDailyResilienceModel{data: [_ | _]}} =
                 DailyResilience.multiple_daily_resilience(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should fail when arguments for multiple daily resilience are not valid" do
      use_cassette "multiple_daily_resilience_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseDailyResilienceModel{data: [_ | _]}} =
                 DailyResilience.multiple_daily_resilience(~D[0024-11-11], ~D[2024-11-12])
      end
    end

    test "should return a single daily resilience" do
      use_cassette "single_daily_resilience" do
        assert {:ok, %DailyResilienceModel{}} =
                 DailyResilience.single_daily_resilience("7f70a05d-0387-4321-89c4-fa77b8e003ba")
      end
    end

    test "should fail when document ID for single daily resilience does not exists" do
      use_cassette "single_daily_resilience_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 DailyResilience.single_daily_resilience("not-existing")
      end
    end
  end
end
