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

  test "runs the HTTP call in the caller process with the per-call timeout" do
    test_pid = self()
    client_pid = Process.whereis(Client)

    adapter = fn request ->
      send(test_pid, {:adapter_ran, self(), request.options[:receive_timeout]})
      # 404 is not retried, so the test stays fast
      {request, Req.Response.new(status: 404, body: "")}
    end

    with_mock ReqFinchAdapter, run: adapter do
      assert {:error, _} = ExOura.single_personal_info(timeout: 1234)
    end

    assert_received {:adapter_ran, ^test_pid, 1234}
    assert Process.whereis(Client) == client_pid
  end

  test "a per-call access_token is sent instead of the shared client token" do
    test_pid = self()

    adapter = fn request ->
      send(test_pid, {:authorization, Req.Request.get_header(request, "authorization")})
      {request, Req.Response.new(status: 404, body: "")}
    end

    with_mock ReqFinchAdapter, run: adapter do
      assert {:error, _} = ExOura.single_personal_info(access_token: "user_b_token")
    end

    assert_received {:authorization, ["Bearer user_b_token"]}
  end

  test "an exhausted known limit returns rate_limited without sleeping or calling the API" do
    start_supervised!(ExOura.RateLimiter)
    reset = System.system_time(:second) + 3600
    ExOura.RateLimiter.update_rate_limit_headers(%{"x-ratelimit-remaining" => ["0"], "x-ratelimit-reset" => ["#{reset}"]})

    adapter = fn _request -> flunk("API must not be called while rate limited") end

    with_mock ReqFinchAdapter, run: adapter do
      {micros, result} = :timer.tc(fn -> ExOura.single_personal_info() end)
      assert {:error, {:rate_limited, retry_after}} = result
      assert retry_after > 0
      assert micros < 1_000_000
    end
  end
end
