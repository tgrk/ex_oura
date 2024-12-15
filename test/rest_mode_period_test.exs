defmodule ExOura.RestModePeriodTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponseRestModePeriodModel
  alias ExOura.Client.RestModePeriodModel

  describe "Rest Mode Period" do
    test "should return multiple rest mode periods" do
      use_cassette "multiple_rest_mode_period" do
        assert {:ok, %MultiDocumentResponseRestModePeriodModel{data: [_ | _]}} =
                 ExOura.multiple_rest_mode_period(~D[2024-03-17], ~D[2024-03-23])
      end
    end

    test "should fail when arguments for multiple rest mode periods are not valid" do
      use_cassette "multiple_rest_mode_period_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseRestModePeriodModel{data: [_ | _]}} =
                 ExOura.multiple_rest_mode_period(~D[0024-11-11], ~D[2024-11-12])
      end
    end

    test "should return a single rest mode period" do
      use_cassette "single_rest_mode_period" do
        assert {:ok, %RestModePeriodModel{}} =
                 ExOura.single_rest_mode_period("bae97990-9a13-4886-9a13-bc44186795d7")
      end
    end

    test "should fail when document ID for single rest mode period does not exists" do
      use_cassette "single_rest_mode_period_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_rest_mode_period("not-existing")
      end
    end
  end
end
