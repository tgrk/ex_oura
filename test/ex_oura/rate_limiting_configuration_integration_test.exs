defmodule ExOura.RateLimitingConfigurationIntegrationTest do
  use ExUnit.Case, async: false

  alias ExOura.RateLimiter

  describe "configuration-driven initialization" do
    test "RateLimiter respects custom configuration limits" do
      # Test with custom limits to verify configuration override
      opts = [
        name: :test_rate_limiter_custom,
        daily_limit: 1000,
        per_minute_limit: 50
      ]

      {:ok, _pid} = start_supervised({RateLimiter, opts})

      status = GenServer.call(:test_rate_limiter_custom, :get_status)
      assert status.remaining == 1000
      assert status.per_minute_remaining == 50
    end

    test "RateLimiter uses config.exs defaults when no options provided" do
      # Test that configuration from config.exs is used as fallback
      opts = [name: :test_rate_limiter_defaults]

      {:ok, _pid} = start_supervised({RateLimiter, opts})

      status = GenServer.call(:test_rate_limiter_defaults, :get_status)
      # These values should match what's in config/config.exs
      assert status.remaining == 5000
      assert status.per_minute_remaining == 300
    end

    test "enabled?/0 reflects compile-time configuration" do
      # This tests that the configuration is properly compiled into the module
      assert RateLimiter.enabled?() == true
    end
  end

  describe "integration with application flow" do
    setup do
      # Start rate limiter with realistic configuration
      opts = [name: :integration_test_limiter, daily_limit: 100, per_minute_limit: 10]
      {:ok, pid} = start_supervised({RateLimiter, opts})
      %{limiter_pid: pid, limiter_name: :integration_test_limiter}
    end

    test "API functions work seamlessly when rate limiting is enabled", %{limiter_name: name} do
      # Test the high-level API functions that would be used in real application flow

      # 1. Check if we can make a request
      assert {:ok, 0} = GenServer.call(name, :check_rate_limit)

      # 2. Record a successful request
      assert :ok = GenServer.cast(name, :record_request)

      # 3. Update state from API response headers (simulating real API usage)
      api_response_headers = %{
        "x-ratelimit-remaining" => "95",
        "x-ratelimit-remaining-minute" => "9"
      }

      assert :ok = GenServer.cast(name, {:update_headers, api_response_headers})

      # 4. Verify the state was updated correctly
      status = GenServer.call(name, :get_status)
      assert status.remaining == 95
      assert status.per_minute_remaining == 9

      # Wait for async operations to complete
      :timer.sleep(10)
    end

    test "rate limiter integrates with application supervision tree", %{limiter_name: name} do
      # Verify that the rate limiter can be supervised and restarted
      original_pid = Process.whereis(name)
      assert is_pid(original_pid)

      # Kill the process to simulate a crash
      Process.exit(original_pid, :kill)

      # Wait for supervisor to restart it
      :timer.sleep(50)

      # Verify it's running again (supervised restart)
      new_pid = Process.whereis(name)
      assert is_pid(new_pid)
      assert new_pid != original_pid

      # Verify it starts with default state after restart
      status = GenServer.call(name, :get_status)
      # Back to initial limits
      assert status.remaining == 100
      assert status.per_minute_remaining == 10
    end
  end

  describe "conditional behavior and client integration" do
    test "client retry mechanism works independently of rate limiter state" do
      # Test that the client retry logic works regardless of RateLimiter state
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 500}}, 1) == true
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 429}}, 1) == true
      assert ExOura.Client.should_retry?({:error, %Req.Response{status: 400}}, 1) == false
      assert ExOura.Client.should_retry?({:error, %Req.TransportError{}}, 1) == true

      # Test exponential backoff calculation
      delay1 = ExOura.Client.retry_delay(1)
      delay2 = ExOura.Client.retry_delay(2)
      delay3 = ExOura.Client.retry_delay(3)

      assert is_integer(delay1) and delay1 > 0
      assert is_integer(delay2) and delay2 > delay1
      assert is_integer(delay3) and delay3 > delay2

      # Delays should be reasonable (with jitter, but still follow exponential pattern roughly)
      # Around 1s base
      assert delay1 < 2000
      # Around 2s base
      assert delay2 < 4000
      # Around 4s base
      assert delay3 < 8000
    end

    test "system handles RateLimiter being unavailable gracefully" do
      # Test that the system doesn't crash when RateLimiter is not available
      # This tests the conditional behavior based on enabled?() and process availability

      original_pid = Process.whereis(RateLimiter)

      # Temporarily unregister the main RateLimiter if it exists
      if original_pid do
        Process.unregister(RateLimiter)
      end

      try do
        # Client retry should still work without RateLimiter
        delay = ExOura.Client.retry_delay(1)
        assert is_integer(delay) and delay > 0

        # Functions that check enabled?() should still work
        enabled = RateLimiter.enabled?()
        assert is_boolean(enabled)

        # Functions that depend on process should handle unavailability
        # (These would typically be wrapped in try/catch in real usage)
        assert :ok = RateLimiter.update_rate_limit_headers(%{})
        assert :ok = RateLimiter.record_request()
      after
        # Restore the registration if there was an original process
        if original_pid && Process.alive?(original_pid) do
          try do
            Process.register(original_pid, RateLimiter)
          rescue
            ArgumentError ->
              # Process might already be registered, ignore
              :ok
          end
        end
      end
    end
  end

  describe "end-to-end configuration scenarios" do
    test "rate limiting can be configured at different levels" do
      # Test that different configuration approaches work together

      # 1. Application-level configuration (via config.exs) - tested in earlier tests
      # 2. Runtime configuration via start_link options

      # Start multiple rate limiters with different configurations
      configs = [
        {1000, 60, :high_volume_limiter},
        {100, 10, :low_volume_limiter},
        {50, 5, :restricted_limiter}
      ]

      pids =
        for {daily, per_minute, name} <- configs do
          opts = [name: name, daily_limit: daily, per_minute_limit: per_minute]
          {:ok, pid} = start_supervised({RateLimiter, opts}, id: name)
          {name, pid}
        end

      # Verify each has correct configuration
      for {name, _pid} <- pids do
        status = GenServer.call(name, :get_status)

        case name do
          :high_volume_limiter ->
            assert status.remaining == 1000
            assert status.per_minute_remaining == 60

          :low_volume_limiter ->
            assert status.remaining == 100
            assert status.per_minute_remaining == 10

          :restricted_limiter ->
            assert status.remaining == 50
            assert status.per_minute_remaining == 5
        end
      end

      # Test that they work independently
      GenServer.cast(:high_volume_limiter, :record_request)

      high_status = GenServer.call(:high_volume_limiter, :get_status)
      low_status = GenServer.call(:low_volume_limiter, :get_status)

      # Decremented
      assert high_status.remaining == 999
      # Unchanged
      assert low_status.remaining == 100
    end
  end
end
