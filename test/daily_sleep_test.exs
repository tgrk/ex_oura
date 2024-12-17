defmodule ExOura.DailySleepTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.DailySleepModel
  alias ExOura.Client.MultiDocumentResponseDailySleepModel

  describe "Daily Sleep" do
    test "should return multiple daily sleep" do
      use_cassette "multiple_daily_sleep" do
        assert {:ok, %MultiDocumentResponseDailySleepModel{data: [_ | _]}} =
                 ExOura.multiple_daily_sleep(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should fail when arguments for multiple daily sleep are not valid" do
      use_cassette "multiple_daily_sleep_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseDailySleepModel{data: [_ | _]}} =
                 ExOura.multiple_daily_sleep(~D[0024-11-11], ~D[2024-11-12])
      end
    end

    test "should return a single daily sleep" do
      use_cassette "single_daily_sleep" do
        assert {:ok, %DailySleepModel{}} =
                 ExOura.single_daily_sleep("8d77bb80-f680-447b-9330-770c8a527d7c")
      end
    end

    test "should fail when document ID for single daily sleep does not exists" do
      use_cassette "single_daily_sleep_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_daily_sleep("not-existing")
      end
    end
  end
end
