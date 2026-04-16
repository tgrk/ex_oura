defmodule ExOura.RingBatteryLevelTest do
  use ExUnit.Case

  import Mock

  alias ExOura.Client

  test "multiple_ring_battery_level delegates to the generated routes with datetime params" do
    with_mock Client, [:passthrough],
      call_api: fn mod, fun, args, opts ->
        send(self(), {:call_api, mod, fun, args, opts})
        {:ok, :stubbed}
      end do
      assert {:ok, :stubbed} =
               ExOura.multiple_ring_battery_level(
                 ~U[2024-11-11 00:00:00Z],
                 ~N[2024-11-12 00:00:00],
                 "token123"
               )

      assert_received {:call_api, Client.RingBatteryLevelRoutes,
                       :multiple_ring_battery_level_documents_v2_usercollection_ring_battery_level_get, [],
                       [
                         start_datetime: ~U[2024-11-11 00:00:00Z],
                         end_datetime: ~N[2024-11-12 00:00:00],
                         next_token: "token123"
                       ]}
    end
  end

  test "multiple_ring_battery_level rejects Date params" do
    assert {:error, :invalid_start_datetime} =
             ExOura.multiple_ring_battery_level(~D[2024-11-11], ~U[2024-11-12 00:00:00Z], "token123")
  end
end
