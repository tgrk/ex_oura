defmodule ExOura.InterbeatIntervalTest do
  use ExUnit.Case

  import Mock

  alias ExOura.Client

  test "multiple_interbeat_interval delegates to the generated routes with datetime params" do
    with_mock Client, [:passthrough],
      call_api: fn mod, fun, args, opts ->
        send(self(), {:call_api, mod, fun, args, opts})
        {:ok, :stubbed}
      end do
      assert {:ok, :stubbed} =
               ExOura.multiple_interbeat_interval(
                 ~U[2024-11-11 00:00:00Z],
                 ~N[2024-11-12 00:00:00],
                 "token123"
               )

      assert_received {:call_api, Client.InterbeatIntervalRoutes,
                       :multiple_interbeat_interval_documents_v2_usercollection_interbeat_interval_get, [],
                       [
                         start_datetime: ~U[2024-11-11 00:00:00Z],
                         end_datetime: ~N[2024-11-12 00:00:00],
                         next_token: "token123"
                       ]}
    end
  end

  test "multiple_interbeat_interval rejects Date params" do
    assert {:error, :invalid_start_datetime} =
             ExOura.multiple_interbeat_interval(~D[2024-11-11], ~U[2024-11-12 00:00:00Z], "token123")
  end
end
