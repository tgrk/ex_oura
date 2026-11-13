defmodule ExOura.ReqRetryIntegrationTest do
  use ExUnit.Case, async: false

  defmodule FlakyAdapter do
    @moduledoc false

    # Fails the first request with 503, then succeeds.
    def run(request) do
      calls = Process.get(:flaky_adapter_calls, 0) + 1
      Process.put(:flaky_adapter_calls, calls)
      status = if calls == 1, do: 503, else: 200
      {request, Req.Response.new(status: status)}
    end
  end

  describe "Req built-in retry functionality" do
    test "Client.should_retry?/2 correctly identifies retryable errors" do
      # Server errors should be retryable
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 500}) == true
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 502}) == true
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 503}) == true
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 504}) == true

      # Rate limiting should be retryable
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 429}) == true

      # Timeout should be retryable
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 408}) == true

      # Transport errors should be retryable
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.TransportError{reason: :econnrefused}) == true
    end

    test "Client.should_retry?/2 correctly identifies non-retryable errors" do
      # Client errors (except 408 and 429) should not be retryable
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 400}) == false
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 401}) == false
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 403}) == false
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 404}) == false
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 422}) == false

      # Successful responses should not be retryable
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 200}) == false
      assert ExOura.Client.should_retry?(%Req.Request{}, %Req.Response{status: 201}) == false

      # Other exceptions should not be retryable
      assert ExOura.Client.should_retry?(%Req.Request{}, %RuntimeError{message: "boom"}) == false
    end

    test "Client.retry_delay/1 calculates exponential backoff with jitter" do
      # Req passes the retry count starting at 0; first retry should be around 1 second
      delay1 = ExOura.Client.retry_delay(0)
      assert delay1 >= 900 and delay1 <= 1100

      # Second retry should be around 2 seconds
      delay2 = ExOura.Client.retry_delay(1)
      assert delay2 >= 1800 and delay2 <= 2200

      # Third retry should be around 4 seconds
      delay3 = ExOura.Client.retry_delay(2)
      assert delay3 >= 3600 and delay3 <= 4400

      # Large attempts should be capped at 30 seconds
      delay_large = ExOura.Client.retry_delay(10)
      assert delay_large <= 30_000
    end

    test "Req retries a 503 response using Client.should_retry?/2" do
      response =
        Req.get!("http://example.test",
          adapter: FlakyAdapter,
          retry: &ExOura.Client.should_retry?/2,
          retry_delay: fn _ -> 0 end,
          retry_log_level: false
        )

      assert response.status == 200
      assert Process.get(:flaky_adapter_calls) == 2
    end
  end
end
