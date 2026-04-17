defmodule ExOura.HeartRateTest do
  use ExUnit.Case

  import Mock

  alias ExOura.Client

  describe "Daily Heart Rate" do
    test "should delegate with datetime params" do
      with_mock Client, [:passthrough],
        call_api: fn mod, fun, args, opts ->
          send(self(), {:call_api, mod, fun, args, opts})
          {:ok, :stubbed}
        end do
        assert {:ok, :stubbed} =
                 ExOura.multiple_heart_rate(~U[2024-11-11 00:00:00Z], ~N[2024-11-12 00:00:00])

        assert_received {:call_api, Client.HeartRateRoutes, :multiple_heartrate_documents_v2_usercollection_heartrate_get,
                         [],
                         [
                           start_datetime: ~U[2024-11-11 00:00:00Z],
                           end_datetime: ~N[2024-11-12 00:00:00]
                         ]}
      end
    end

    test "should reject Date params for datetime endpoints" do
      assert {:error, :invalid_start_datetime} =
               ExOura.multiple_heart_rate(~D[2024-11-11], ~U[2024-11-12 00:00:00Z])
    end

    test "should reject invalid end datetime params for datetime endpoints" do
      assert {:error, :invalid_end_datetime} =
               ExOura.multiple_heart_rate(~U[2024-11-11 00:00:00Z], ~D[2024-11-12])
    end

    test "should reject inverted datetime ranges" do
      assert {:error, :end_datetime_before_start_datetime} =
               ExOura.multiple_heart_rate(~U[2024-11-12 00:00:00Z], ~N[2024-11-11 00:00:00])
    end
  end
end
