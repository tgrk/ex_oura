defmodule ExOura.RingConfigurationTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponseRingConfigurationModel
  alias ExOura.Client.RingConfigurationModel

  describe "Ring Configuration" do
    test "should return multiple ring configurations (ignores date parameters)" do
      use_cassette "multiple_ring_configuration" do
        # Ring Configuration endpoint doesn't actually use date parameters but the wrapper requires them
        assert {:ok, %MultiDocumentResponseRingConfigurationModel{data: [_ | _]}} =
                 ExOura.multiple_ring_configuration(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should return multiple ring configurations with next_token" do
      use_cassette "multiple_ring_configuration_with_token" do
        assert {:ok, %MultiDocumentResponseRingConfigurationModel{data: [_ | _]}} =
                 ExOura.multiple_ring_configuration(~D[2024-11-11], ~D[2024-11-12], "token123")
      end
    end

    test "should handle invalid date arguments (dates are ignored anyway)" do
      use_cassette "multiple_ring_configuration_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseRingConfigurationModel{data: [_ | _]}} =
                 ExOura.multiple_ring_configuration(~D[0024-11-11], ~D[2024-11-12])
      end
    end

    test "should return a single ring configuration" do
      use_cassette "single_ring_configuration" do
        assert {:ok, %RingConfigurationModel{}} =
                 ExOura.single_ring_configuration("cb3317b2-3ec6-46f2-b62d-210e87c41268")
      end
    end

    test "should fail when document ID for single ring configuration does not exist" do
      use_cassette "single_ring_configuration_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_ring_configuration("not-existing")
      end
    end

    test "should handle malformed document ID" do
      use_cassette "single_ring_configuration_malformed" do
        assert {:error, %{detail: _message}} =
                 ExOura.single_ring_configuration("malformed-id-format")
      end
    end
  end
end
