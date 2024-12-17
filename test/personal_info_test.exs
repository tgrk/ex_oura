defmodule ExOura.PersonalInfoTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.PersonalInfoResponse

  describe "Daily Activity" do
    test "should return a single personal info" do
      use_cassette "single_personal_info" do
        assert {:ok, %PersonalInfoResponse{}} = ExOura.single_personal_info()
      end
    end
  end
end
