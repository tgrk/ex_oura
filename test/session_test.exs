defmodule ExOura.SessionTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.MultiDocumentResponseSessionModel
  alias ExOura.Client.SessionModel
  alias ExOura.Session

  describe "Session" do
    test "should return multiple sessions" do
      use_cassette "multiple_session" do
        assert {:ok, %MultiDocumentResponseSessionModel{data: [_ | _]}} =
                 Session.multiple_session(~D[2024-10-09], ~D[2024-11-03])
      end
    end

    test "should fail when arguments for multiple sessions are not valid" do
      use_cassette "multiple_session_invalid_arguments" do
        assert {:ok, %MultiDocumentResponseSessionModel{data: []}} =
                 Session.multiple_session(1, 2)
      end
    end

    test "should return a single session" do
      use_cassette "single_session" do
        assert {:ok, %SessionModel{}} =
                 Session.single_session("759082a5-76ef-4e48-b285-f84902428322")
      end
    end

    test "should fail when document ID for single session does not exists" do
      use_cassette "single_session_non_existing" do
        assert {:error, %{detail: "Document not found."}} =
                 Session.single_session("not-existing")
      end
    end
  end
end
