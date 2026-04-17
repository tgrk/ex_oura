defmodule ExOura.SandboxRoutesTest do
  use ExUnit.Case, async: false

  import Mock

  alias ExOura.Client
  alias ExOura.Client.SandboxRoutes

  test "multiple sandbox routes build the expected request payloads" do
    test_pid = self()

    with_mock Client, [:passthrough],
      request: fn operation ->
        send(test_pid, {:sandbox_request, operation})
        {:ok, operation}
      end do
      assert {:ok, %{url: "/v2/sandbox/usercollection/daily_activity", query: query}} =
               SandboxRoutes.sandbox_multiple_daily_activity_documents_v2_sandbox_usercollection_daily_activity_get(
                 client: Client,
                 start_date: ~D[2024-01-01],
                 end_date: ~D[2024-01-02]
               )

      assert query[:start_date] == ~D[2024-01-01]
      assert query[:end_date] == ~D[2024-01-02]

      assert_received {:sandbox_request,
                       %{
                         call:
                           {SandboxRoutes,
                            :sandbox_multiple_daily_activity_documents_v2_sandbox_usercollection_daily_activity_get}
                       }}

      assert {:ok, %{url: "/v2/sandbox/usercollection/heartrate", query: query}} =
               SandboxRoutes.sandbox_multiple_heartrate_documents_v2_sandbox_usercollection_heartrate_get(
                 client: Client,
                 start_datetime: ~U[2024-01-01 00:00:00Z],
                 end_datetime: ~N[2024-01-02 00:00:00]
               )

      assert query[:start_datetime] == ~U[2024-01-01 00:00:00Z]
      assert query[:end_datetime] == ~N[2024-01-02 00:00:00]

      assert {:ok, %{url: "/v2/sandbox/usercollection/ring_configuration", query: query}} =
               SandboxRoutes.sandbox_multiple_ring_configuration_documents_v2_sandbox_usercollection_ring_configuration_get(
                 client: Client,
                 next_token: "page-2"
               )

      assert query[:next_token] == "page-2"

      assert {:ok, %{url: "/v2/sandbox/usercollection/workout", query: query}} =
               SandboxRoutes.sandbox_multiple_workout_documents_v2_sandbox_usercollection_workout_get(
                 client: Client,
                 start_date: ~D[2024-01-01],
                 end_date: ~D[2024-01-02],
                 next_token: "page-2"
               )

      assert query[:start_date] == ~D[2024-01-01]
      assert query[:end_date] == ~D[2024-01-02]
      assert query[:next_token] == "page-2"
    end
  end

  test "single sandbox routes interpolate document identifiers into request URLs" do
    single_ring_configuration =
      &SandboxRoutes.sandbox_single_ring_configuration_document_v2_sandbox_usercollection_ring_configuration_document_id_get/2

    with_mock Client, [:passthrough], request: fn operation -> {:ok, operation} end do
      assert {:ok, %{url: "/v2/sandbox/usercollection/daily_activity/activity-123"}} =
               SandboxRoutes.sandbox_single_daily_activity_document_v2_sandbox_usercollection_daily_activity_document_id_get(
                 "activity-123",
                 client: Client
               )

      assert {:ok, %{url: "/v2/sandbox/usercollection/daily_resilience/resilience-123"}} =
               SandboxRoutes.sandbox_single_daily_resilience_document_v2_sandbox_usercollection_daily_resilience_document_id_get(
                 "resilience-123",
                 client: Client
               )

      assert {:ok, %{url: "/v2/sandbox/usercollection/ring_configuration/ring-config-123"}} =
               single_ring_configuration.("ring-config-123", client: Client)

      assert {:ok, %{url: "/v2/sandbox/usercollection/daily_sleep/sleep-123"}} =
               SandboxRoutes.sandbox_single_daily_sleep_document_v2_sandbox_usercollection_daily_sleep_document_id_get(
                 "sleep-123",
                 client: Client
               )
    end
  end
end
