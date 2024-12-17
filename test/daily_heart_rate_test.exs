defmodule ExOura.HeartRateTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.TimeSeriesResponseHeartRateModel

  describe "Daily Heart Rate" do
    test "should return multiple heart rates" do
      use_cassette "multiple_heart_rate" do
        assert {:ok, %TimeSeriesResponseHeartRateModel{data: [_ | _]}} =
                 ExOura.multiple_heart_rate(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should fail when arguments for multiple heart rates are not valid" do
      use_cassette "multiple_heart_rate_invalid_arguments" do
        assert {:ok, %TimeSeriesResponseHeartRateModel{data: [_ | _]}} =
                 ExOura.multiple_heart_rate(~D[0024-11-11], ~D[2024-11-12])
      end
    end
  end
end
