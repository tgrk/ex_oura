defmodule ExOura.RateLimitingConfigurationIntegrationTest do
  use ExUnit.Case, async: false

  alias ExOura.RateLimiter

  describe "rate limiting with custom configuration" do
    test "RateLimiter starts with custom limits" do
      # Start with custom configuration
      opts = [
        name: :test_rate_limiter_custom,
        daily_limit: 1000,
        per_minute_limit: 50
      ]

      {:ok, _pid} = start_supervised({RateLimiter, opts})

      # Get status using the custom name
      status = GenServer.call(:test_rate_limiter_custom, :get_status)

      assert status.remaining == 1000
      assert status.per_minute_remaining == 50
    end

    test "RateLimiter starts with default config values" do
      # Start with minimal options, should use config defaults
      opts = [name: :test_rate_limiter_defaults]

      {:ok, _pid} = start_supervised({RateLimiter, opts})

      # Get status using the custom name
      status = GenServer.call(:test_rate_limiter_defaults, :get_status)

      # Should use configured defaults (5000, 300 from config.exs)
      assert status.remaining == 5000
      assert status.per_minute_remaining == 300
    end

    test "enabled?/0 reflects configuration" do
      # This tests the compile-time configuration
      assert RateLimiter.enabled?() == true
    end
  end

  describe "conditional behavior based on enabled state" do
    setup do
      # Start a test rate limiter
      opts = [name: :test_conditional_limiter, daily_limit: 100, per_minute_limit: 10]
      {:ok, pid} = start_supervised({RateLimiter, opts})
      %{limiter_pid: pid}
    end

    test "functions work when rate limiting is enabled", %{limiter_pid: _pid} do
      # Test the functions directly with the named process

      # Test check_rate_limit using the custom name
      assert {:ok, 0} = GenServer.call(:test_conditional_limiter, :check_rate_limit)

      # Test record_request
      assert :ok = GenServer.cast(:test_conditional_limiter, :record_request)

      # Test update_rate_limit_headers
      headers = %{"x-ratelimit-remaining" => "95"}
      assert :ok = GenServer.cast(:test_conditional_limiter, {:update_headers, headers})

      # Test get_status
      status = GenServer.call(:test_conditional_limiter, :get_status)
      assert is_map(status)
      assert status.remaining <= 100

      # Wait a bit for async operations
      :timer.sleep(10)
    end
  end

  describe "integration with req retry mechanism" do
    test "client retry works with rate limiting enabled" do
      # Test that the client retry functions work
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 500}}, 1) == true
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 400}}, 1) == false

      # Test delay calculation
      delay = ExOura.Client.retry_delay(1)
      assert is_integer(delay) and delay > 0
    end

    test "client retry handles RateLimiter not running" do
      # Ensure RateLimiter is not registered
      if Process.whereis(RateLimiter) do
        original_pid = Process.whereis(RateLimiter)
        Process.unregister(RateLimiter)

        try do
          # Should not crash even without RateLimiter
          delay = ExOura.Client.retry_delay(1)
          assert is_integer(delay) and delay > 0
        after
          if Process.alive?(original_pid) do
            Process.register(original_pid, RateLimiter)
          end
        end
      else
        delay = ExOura.Client.retry_delay(1)
        assert is_integer(delay) and delay > 0
      end
    end
  end
end
