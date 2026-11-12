defmodule ExOura.RateLimiterTest do
  use ExUnit.Case, async: true

  alias ExOura.RateLimiter

  @one_hour_in_seconds 3600

  setup do
    # Start a fresh rate limiter for each test
    pid = start_supervised!({RateLimiter, [daily_limit: 100, per_minute_limit: 10]})
    {:ok, rate_limiter: pid}
  end

  describe "check_rate_limit/0" do
    test "allows requests when limits are not exceeded" do
      assert {:ok, delay} = RateLimiter.check_rate_limit()
      assert delay >= 0
    end

    test "blocks requests when daily limit is exceeded" do
      # Update state to simulate daily limit reached
      headers = %{
        "x-ratelimit-remaining" => "0",
        "x-ratelimit-reset" => "#{System.system_time(:second) + @one_hour_in_seconds}"
      }

      RateLimiter.update_rate_limit_headers(headers)

      assert {:error, {:rate_limited, retry_after}} = RateLimiter.check_rate_limit()
      assert retry_after > 0
    end

    test "blocks requests when per-minute limit is exceeded" do
      # Update state to simulate per-minute limit reached
      future_time = System.system_time(:second) + 60

      headers = %{
        "x-ratelimit-remaining-minute" => "0",
        "x-ratelimit-reset-minute" => "#{future_time}"
      }

      RateLimiter.update_rate_limit_headers(headers)

      assert {:error, {:rate_limited, retry_after}} = RateLimiter.check_rate_limit()
      assert retry_after > 0
      assert retry_after <= 60
    end

    test "applies throttling when making rapid requests with low remaining limit" do
      # Simulate low remaining requests
      headers = %{
        "x-ratelimit-remaining" => "50",
        "x-ratelimit-remaining-minute" => "5"
      }

      RateLimiter.update_rate_limit_headers(headers)

      # Make a request to set last_request_time
      RateLimiter.record_request()

      # Immediately try another request - should suggest throttling
      assert {:ok, delay} = RateLimiter.check_rate_limit()
      assert delay > 0
    end
  end

  describe "update_rate_limit_headers/1" do
    test "updates state from standard rate limit headers" do
      headers = %{
        "x-ratelimit-remaining" => "45",
        "x-ratelimit-reset" => "1693843200",
        "x-ratelimit-remaining-minute" => "8",
        "x-ratelimit-reset-minute" => "1693839660"
      }

      RateLimiter.update_rate_limit_headers(headers)
      status = RateLimiter.get_status()

      assert status.remaining == 45
      assert status.reset_time == 1_693_843_200
      assert status.per_minute_remaining == 8
      assert status.per_minute_reset == 1_693_839_660
    end

    test "handles headers as list of tuples" do
      headers = [
        {"X-RateLimit-Remaining", "30"},
        {"X-RateLimit-Reset", "1693843200"}
      ]

      RateLimiter.update_rate_limit_headers(headers)
      status = RateLimiter.get_status()

      assert status.remaining == 30
      assert status.reset_time == 1_693_843_200
    end

    test "reads Req's list-valued headers and blocks when the daily limit is used up" do
      reset = System.system_time(:second) + @one_hour_in_seconds
      headers = Req.Response.new(headers: [{"x-ratelimit-remaining", "0"}, {"x-ratelimit-reset", "#{reset}"}]).headers
      assert %{"x-ratelimit-remaining" => ["0"]} = headers

      RateLimiter.update_rate_limit_headers(headers)

      assert %{remaining: 0, reset_time: ^reset} = RateLimiter.get_status()
      assert {:error, {:rate_limited, retry_after}} = RateLimiter.check_rate_limit()
      assert retry_after > 0
    end

    test "keeps the lowest count within a reset window, even if replies arrive out of order" do
      reset = System.system_time(:second) + @one_hour_in_seconds

      RateLimiter.update_rate_limit_headers(%{"x-ratelimit-remaining" => "0", "x-ratelimit-reset" => "#{reset}"})
      # An older reply from the same window arrives late
      RateLimiter.update_rate_limit_headers(%{"x-ratelimit-remaining" => "5", "x-ratelimit-reset" => "#{reset}"})

      assert %{remaining: 0} = RateLimiter.get_status()
      assert {:error, {:rate_limited, _}} = RateLimiter.check_rate_limit()

      # A new window may raise the count again
      new_reset = reset + 86_400
      RateLimiter.update_rate_limit_headers(%{"x-ratelimit-remaining" => "100", "x-ratelimit-reset" => "#{new_reset}"})
      assert %{remaining: 100, reset_time: ^new_reset} = RateLimiter.get_status()
    end

    test "takes the newest count when no reset window is known" do
      RateLimiter.update_rate_limit_headers(%{"x-ratelimit-remaining-minute" => "3"})
      RateLimiter.update_rate_limit_headers(%{"x-ratelimit-remaining-minute" => "200"})

      assert %{per_minute_remaining: 200, per_minute_reset: nil} = RateLimiter.get_status()
    end

    test "ignores invalid header values" do
      original_status = RateLimiter.get_status()

      headers = %{
        "x-ratelimit-remaining" => "invalid",
        "x-ratelimit-reset" => "not_a_number"
      }

      RateLimiter.update_rate_limit_headers(headers)
      new_status = RateLimiter.get_status()

      # Should remain unchanged
      assert new_status.remaining == original_status.remaining
      assert new_status.reset_time == original_status.reset_time
    end

    test "handles missing headers gracefully" do
      original_status = RateLimiter.get_status()

      RateLimiter.update_rate_limit_headers(%{})
      new_status = RateLimiter.get_status()

      # Should remain unchanged
      assert new_status.remaining == original_status.remaining
      assert new_status.per_minute_remaining == original_status.per_minute_remaining
    end
  end

  describe "record_request/0" do
    test "updates last request time without touching remaining counts" do
      original_status = RateLimiter.get_status()

      for _ <- 1..20, do: RateLimiter.record_request()
      new_status = RateLimiter.get_status()

      assert new_status.remaining == original_status.remaining
      assert new_status.per_minute_remaining == original_status.per_minute_remaining
      assert new_status.last_request_time >= original_status.last_request_time
    end
  end

  describe "get_status/0" do
    test "returns current rate limit state" do
      status = RateLimiter.get_status()

      assert is_map(status)
      assert Map.has_key?(status, :remaining)
      assert Map.has_key?(status, :reset_time)
      assert Map.has_key?(status, :per_minute_remaining)
      assert Map.has_key?(status, :per_minute_reset)
      assert Map.has_key?(status, :last_request_time)
    end
  end

  describe "initialization" do
    test "starts with custom limits" do
      # Start without a name to avoid collisions
      {:ok, pid} = RateLimiter.start_link(daily_limit: 500, per_minute_limit: 50, name: nil)

      status = GenServer.call(pid, :get_status)
      assert status.remaining == 500
      assert status.per_minute_remaining == 50

      GenServer.stop(pid)
    end

    test "starts with default limits when no options provided" do
      # Start without a name to avoid collisions
      {:ok, pid} = RateLimiter.start_link(name: nil)

      status = GenServer.call(pid, :get_status)
      # Default daily limit
      assert status.remaining == 5000
      # Default per-minute limit
      assert status.per_minute_remaining == 300

      GenServer.stop(pid)
    end
  end

  describe "rate limiting scenarios" do
    test "allows burst of requests within per-minute limit" do
      # Make several requests quickly
      results =
        for _ <- 1..5 do
          RateLimiter.record_request()
          RateLimiter.check_rate_limit()
        end

      # All should be allowed (though some may have delays)
      assert Enum.all?(results, fn
               {:ok, _delay} -> true
               _ -> false
             end)
    end

    test "rejects requests when both daily and per-minute limits hit" do
      future_time = System.system_time(:second) + @one_hour_in_seconds

      headers = %{
        "x-ratelimit-remaining" => "0",
        "x-ratelimit-reset" => "#{future_time}",
        "x-ratelimit-remaining-minute" => "0",
        "x-ratelimit-reset-minute" => "#{future_time}"
      }

      RateLimiter.update_rate_limit_headers(headers)

      assert {:error, {:rate_limited, _}} = RateLimiter.check_rate_limit()
    end
  end
end
