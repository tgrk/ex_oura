defmodule OuraCloudAPITest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    {:ok, client} = OuraCloudAPI.new()
    {:ok, %{client: client}}
  end

  test "authorize client", %{client: client} do
    use_cassette "authorize" do
      resp = OuraCloudAPI.authorize_url!(client)
      IO.inspect(resp, label: :authorize)
      assert false
    end
  end
end
