defmodule ExOura.EnhancedTagTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.EnhancedTagModel
  alias ExOura.Client.MultiDocumentResponseEnhancedTagModel

  describe "Enhanced Tag" do
    test "should return multiple enhanced tags" do
      use_cassette "multiple_enhanced_tag" do
        assert {:ok, %MultiDocumentResponseEnhancedTagModel{data: [_ | _]}} =
                 ExOura.multiple_enhanced_tag(~D[2024-08-05], ~D[2024-11-09])
      end
    end

    test "should fail when arguments for multiple enhanced tags are not valid" do
      use_cassette "multiple_enhanced_tag_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseEnhancedTagModel{data: [_ | _]}} =
                 ExOura.multiple_enhanced_tag(~D[0024-11-11], ~D[2024-11-12])
      end
    end

    test "should return a single enhanced tag" do
      use_cassette "single_enhanced_tag" do
        assert {:ok, %EnhancedTagModel{}} =
                 ExOura.single_enhanced_tag("a8d86c51-90f4-460d-b92c-6d68173fbce6")
      end
    end

    test "should fail when document ID for single enhanced tag does not exists" do
      use_cassette "single_enhanced_tag_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.single_enhanced_tag("not-existing")
      end
    end
  end
end
