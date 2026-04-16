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
               ExOura.multiple_ring_battery_level(~D[2024-11-11], ~D[2024-11-12], "token123")

      assert_received {:call_api, Client.RingBatteryLevelRoutes,
                       :multiple_ring_battery_level_documents_v2_usercollection_ring_battery_level_get, [],
                       [
                         start_datetime: ~D[2024-11-11],
                         end_datetime: ~D[2024-11-12],
                         next_token: "token123"
                       ]}
    end
  end
end
