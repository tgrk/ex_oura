defmodule ExOura.DailyCardiovascularAgeTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponseDailyCardiovascularAgeModel

  describe "Daily Cardiovascular Age" do
    test "should return multiple daily cardiovascular age" do
      use_cassette "multiple_daily_cardiovascular_age" do
        assert {:ok, %MultiDocumentResponseDailyCardiovascularAgeModel{data: [_ | _]}} =
                 ExOura.multiple_daily_cardiovascular_age(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should fail when arguments for multiple daily cardiovascular age are not valid" do
      assert {:error, :invalid_end_date} =
               ExOura.multiple_daily_cardiovascular_age(~D[0024-11-11], ~S[2024-11-12])
    end
  end
end
