defmodule ExOura.ReqRetryIntegrationTest do
  use ExUnit.Case, async: false

  import Mock

  alias ExOura.Client
  alias ExOura.Client.PersonalInfoResponse
  alias ExOura.Test.Support.ReqFinchAdapter

  setup do
    if pid = Process.whereis(Client), do: GenServer.stop(pid, :normal, 1000)
    {:ok, _pid} = Client.start_link("bearer_token")
    on_exit(fn -> if pid = Process.whereis(Client), do: GenServer.stop(pid, :normal, 1000) end)
    :ok
  end

  test "retries a GET request that first gets a 503" do
    attempts = :counters.new(1, [])

    adapter = fn request ->
      :counters.add(attempts, 1, 1)

      response =
        if :counters.get(attempts, 1) == 1 do
          Req.Response.new(status: 503, body: "")
        else
          Req.Response.new(
            status: 200,
            headers: %{"content-type" => ["application/json"]},
            body: ~s({"id": "user-1", "age": 30})
          )
        end

      {request, response}
    end

    with_mock ReqFinchAdapter, run: adapter do
      assert {:ok, %PersonalInfoResponse{id: "user-1", age: 30}} = ExOura.single_personal_info()
    end

    assert :counters.get(attempts, 1) == 2
  end
end
