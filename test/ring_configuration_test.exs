defmodule ExOura.RingConfigurationTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponseRingConfigurationModel
  alias ExOura.Client.RingConfigurationModel
  alias ExOura.RingConfiguration

  describe "Ring Configuration" do
    test "should return multiple ring configurations" do
      use_cassette "multiple_ring_configuration" do
        assert {:ok, %MultiDocumentResponseRingConfigurationModel{data: [_ | _]}} =
                 RingConfiguration.multiple_ring_configuration(~D[2024-11-11], ~D[2024-11-12])
      end
    end

    test "should fail when arguments for multiple ring configurations are not valid" do
      use_cassette "multiple_ring_configuration_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseRingConfigurationModel{data: [_ | _]}} =
                 RingConfiguration.multiple_ring_configuration(~D[0024-11-11], ~D[2024-11-12])
      end
    end

    test "should return a single ring configuration" do
      use_cassette "single_ring_configuration" do
        assert {:ok, %RingConfigurationModel{}} =
                 RingConfiguration.single_ring_configuration(
                   "cb3317b2-3ec6-46f2-b62d-210e87c41268"
                 )
      end
    end

    test "should fail when document ID for single ring configuration does not exists" do
      use_cassette "single_ring_configuration_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 RingConfiguration.single_ring_configuration("not-existing")
      end
    end
  end
end
