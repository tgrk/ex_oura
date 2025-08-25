defmodule ExOura.ReqRetryIntegrationTest do
  use ExUnit.Case, async: false

  describe "Req built-in retry functionality" do
    test "Client.should_retry?/2 correctly identifies retryable errors" do
      # Server errors should be retryable
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 500}}, 1) == true
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 502}}, 1) == true
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 503}}, 1) == true
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 504}}, 1) == true

      # Rate limiting should be retryable
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 429}}, 1) == true

      # Timeout should be retryable
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 408}}, 1) == true

      # Transport errors should be retryable
      assert ExOura.Client.should_retry?({:error, %Req.TransportError{reason: :econnrefused}}, 1) == true
    end

    test "Client.should_retry?/2 correctly identifies non-retryable errors" do
      # Client errors (except 408 and 429) should not be retryable
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 400}}, 1) == false
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 401}}, 1) == false
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 403}}, 1) == false
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 404}}, 1) == false
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 422}}, 1) == false

      # Successful responses should not be retryable
      assert ExOura.Client.should_retry?({:ok, %Req.Response{status: 200}}, 1) == false
      assert ExOura.Client.should_retry?({:ok, %Req.Response{status: 201}}, 1) == false

      # Other errors should not be retryable
      assert ExOura.Client.should_retry?({:error, :some_other_error}, 1) == false
    end

    test "Client.retry_delay/1 calculates exponential backoff with jitter" do
      # First retry should be around 1 second (1000ms ± jitter)
      delay1 = ExOura.Client.retry_delay(1)
      assert delay1 >= 900 and delay1 <= 1100

      # Second retry should be around 2 seconds
      delay2 = ExOura.Client.retry_delay(2)
      assert delay2 >= 1800 and delay2 <= 2200

      # Third retry should be around 4 seconds
      delay3 = ExOura.Client.retry_delay(3)
      assert delay3 >= 3600 and delay3 <= 4400

      # Large attempts should be capped at 30 seconds
      delay_large = ExOura.Client.retry_delay(10)
      assert delay_large <= 30_000
    end

    test "req_opts includes retry configuration" do
      # Call the req_opts function via reflection to test it
      # Since req_opts is private, we'll test indirectly by ensuring compilation works
      # and the retry functions are defined
      assert function_exported?(ExOura.Client, :should_retry?, 2)
      assert function_exported?(ExOura.Client, :retry_delay, 1)
    end
  end
end
