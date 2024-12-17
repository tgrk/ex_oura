defmodule ExOura.SleepTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponseSleepModel
  alias ExOura.Client.SleepModel

  describe "Sleep" do
    test "should return multiple sleep" do
      use_cassette "multiple_sleep" do
        assert {:ok, %MultiDocumentResponseSleepModel{data: [_ | _]}} =
                 ExOura.multiple_sleep(~D[2024-10-09], ~D[2024-11-03])
      end
    end

    test "should fail when arguments for multiple sleep are not valid" do
      use_cassette "multiple_sleep_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseSleepModel{data: []}} =
                 ExOura.multiple_sleep(1, 2)
      end
    end

    test "should return a single sleep" do
      use_cassette "single_sleep" do
        assert {:ok, %SleepModel{}} =
                 ExOura.single_sleep("96e7772a-64a7-4342-9c5f-3e5ed9e64d6d")
      end
    end

    test "should fail when document ID for single sleep does not exists" do
      use_cassette "single_sleep_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_sleep("not-existing")
      end
    end
  end
end
