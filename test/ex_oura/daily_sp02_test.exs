defmodule ExOura.DailySp02Test do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.DailySpO2Model
  alias ExOura.Client.MultiDocumentResponseDailySpO2Model

  describe "Daily Sp02" do
    test "should return multiple daily Sp02" do
      use_cassette "multiple_daily_sp02" do
        assert {:ok, %MultiDocumentResponseDailySpO2Model{data: [_ | _]}} =
                 ExOura.multiple_daily_sp02(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should fail when arguments for multiple daily Sp02 are not valid" do
      use_cassette "multiple_daily_sp02_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseDailySpO2Model{data: [_ | _]}} =
                 ExOura.multiple_daily_sp02(~D[0024-11-11], ~D[2024-11-12])
      end
    end

    test "should return a single daily Sp02" do
      use_cassette "single_daily_sp02" do
        assert {:ok, %DailySpO2Model{}} =
                 ExOura.single_daily_sp02("aab63549-23de-437a-9ece-fee8e8ab2a7d")
      end
    end

    test "should fail when document ID for single daily Sp02 does not exists" do
      use_cassette "single_daily_sp02_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_daily_sp02("not-existing")
      end
    end
  end
end
