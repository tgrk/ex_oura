defmodule ExOura.Vo2MaxTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponseVo2MaxModel
  alias ExOura.Client.Vo2MaxModel

  describe "Vo2 Max" do
    test "should return multiple vo2 max" do
      use_cassette "multiple_vo2_max" do
        assert {:ok, %MultiDocumentResponseVo2MaxModel{data: [_ | _]}} =
                 ExOura.multiple_vo2_max(~D[2023-09-17], ~D[2024-11-03])
      end
    end

    test "should fail when arguments for multiple vo2 max are not valid" do
      use_cassette "multiple_vo2_max_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseVo2MaxModel{data: []}} =
                 ExOura.multiple_vo2_max(1, 2)
      end
    end

    test "should return a single vo2 max" do
      use_cassette "single_vo2_max" do
        assert {:ok, %Vo2MaxModel{}} =
                 ExOura.single_vo2_max("7c4d1981-ad05-4f24-b2c7-9ac826936555")
      end
    end

    test "should fail when document ID for single vo2 max does not exists" do
      use_cassette "single_vo2_max_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_vo2_max("not-existing")
      end
    end
  end
end
