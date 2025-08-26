defmodule ExOura.TagTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponseTagModel
  alias ExOura.Client.TagModel

  describe "Tag (Deprecated)" do
    @tag :deprecated
    test "should return multiple tags" do
      use_cassette "multiple_tag" do
        assert {:ok,
                %MultiDocumentResponseTagModel{
                  data: [
                    %TagModel{
                      day: ~D[2024-01-15],
                      id: "tag-id-1",
                      tags: ["workout"],
                      timestamp: ~U[2024-01-15 10:00:00Z],
                      text: "Morning workout"
                    }
                  ]
                }} = ExOura.Tag.multiple_tag(~D[2024-01-15], ~D[2024-01-16])
      end
    end

    @tag :deprecated
    test "should return multiple tags with next_token" do
      use_cassette "multiple_tag_with_token" do
        assert {:ok,
                %MultiDocumentResponseTagModel{
                  data: [%TagModel{} | _],
                  next_token: nil
                }} = ExOura.Tag.multiple_tag(~D[2024-01-15], ~D[2024-01-16], "token123")
      end
    end

    @tag :deprecated
    test "should handle invalid date range for multiple tags" do
      use_cassette "multiple_tag_invalid_dates" do
        assert {:error, %{detail: _message}} =
                 ExOura.Tag.multiple_tag(~D[2025-01-15], ~D[2024-01-16])
      end
    end

    @tag :deprecated
    test "should return a single tag" do
      use_cassette "single_tag" do
        assert {:ok,
                %TagModel{
                  day: ~D[2024-01-15],
                  id: "tag-id-1",
                  tags: ["workout"],
                  timestamp: ~U[2024-01-15 10:00:00Z],
                  text: "Morning workout"
                }} = ExOura.Tag.single_tag("tag-id-1")
      end
    end

    @tag :deprecated
    test "should return error for non-existing tag ID" do
      use_cassette "single_tag_not_found" do
        assert {:error, %{detail: "Document not found."}} =
                 ExOura.Tag.single_tag("non-existing-id")
      end
    end

    @tag :deprecated
    test "should handle malformed tag ID" do
      use_cassette "single_tag_malformed_id" do
        assert {:error, %{detail: _message}} =
                 ExOura.Tag.single_tag("malformed-id-format")
      end
    end
  end
end
