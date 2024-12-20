defmodule ExOura.SleepTimeTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponseSleepTimeModel
  alias ExOura.Client.SleepTimeModel

  describe "Sleep Time" do
    test "should return multiple sleep timeg" do
      use_cassette "multiple_sleep_time" do
        assert {:ok, %MultiDocumentResponseSleepTimeModel{data: [_ | _]}} =
                 ExOura.multiple_sleep_time(~D[2024-10-09], ~D[2024-11-03])
      end
    end

    test "should fail when arguments for multiple sleep time are not valid" do
      assert {:error, :invalid_start_date} = ExOura.multiple_sleep_time(1, 2)
    end

    test "should return a single sleep time" do
      use_cassette "single_sleep_time" do
        assert {:ok, %SleepTimeModel{}} =
                 ExOura.single_sleep_time("b3a48c58-3f61-4cef-b091-d03ec3503a56")
      end
    end

    test "should fail when document ID for single sleep time does not exists" do
      use_cassette "single_sleep_time_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_sleep_time("not-existing")
      end
    end
  end
end
