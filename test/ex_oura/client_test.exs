defmodule ExOura.ClientTest do
  use ExUnit.Case, async: false

  import Mock

  alias ExOura.Client
  alias ExOura.Client.DailyActivityRoutes
  alias ExOura.Client.HeartRateRoutes
  alias ExOura.Client.WebhookSubscriptionRoutes

  setup do
    case Process.whereis(Client) do
      pid when is_pid(pid) ->
        GenServer.stop(pid, :normal, 1000)

      nil ->
        :ok
    end

    :ok
  end

  setup do
    original_env = %{
      client_id: System.get_env("OURA_CLIENT_ID"),
      client_secret: System.get_env("OURA_CLIENT_SECRET")
    }

    on_exit(fn ->
      restore_env("OURA_CLIENT_ID", original_env.client_id)
      restore_env("OURA_CLIENT_SECRET", original_env.client_secret)
    end)

    :ok
  end

  describe "range helper functions" do
    test "date_range_args omits nil next_token" do
      assert Client.date_range_args(~D[2024-01-01], ~D[2024-01-02]) == [
               start_date: ~D[2024-01-01],
               end_date: ~D[2024-01-02]
             ]
    end

    test "date_range_args includes next_token when provided" do
      assert Client.date_range_args(~D[2024-01-01], ~D[2024-01-02], "page-2") == [
               start_date: ~D[2024-01-01],
               end_date: ~D[2024-01-02],
               next_token: "page-2"
             ]
    end

    test "datetime_range_args omits nil next_token" do
      assert Client.datetime_range_args(~U[2024-01-01 00:00:00Z], ~N[2024-01-02 00:00:00]) == [
               start_datetime: ~U[2024-01-01 00:00:00Z],
               end_datetime: ~N[2024-01-02 00:00:00]
             ]
    end

    test "datetime_range_args includes next_token when provided" do
      assert Client.datetime_range_args(~U[2024-01-01 00:00:00Z], ~N[2024-01-02 00:00:00], "page-2") == [
               start_datetime: ~U[2024-01-01 00:00:00Z],
               end_datetime: ~N[2024-01-02 00:00:00],
               next_token: "page-2"
             ]
    end
  end

  describe "call_api/4" do
    test "returns client_not_ready when no client process is available" do
      assert {:error, :client_not_ready} =
               Client.call_api(
                 DailyActivityRoutes,
                 :multiple_daily_activity_documents_v2_usercollection_daily_activity_get,
                 [],
                 []
               )
    end

    test "delegates to the route module when a client option is provided" do
      with_mock HeartRateRoutes, [:passthrough],
        multiple_heartrate_documents_v2_usercollection_heartrate_get: fn opts ->
          send(self(), {:heart_rate_route_opts, opts})
          {:ok, :delegated}
        end do
        assert {:ok, :delegated} =
                 Client.call_api(
                   HeartRateRoutes,
                   :multiple_heartrate_documents_v2_usercollection_heartrate_get,
                   [],
                   client: Client,
                   start_datetime: ~U[2024-01-01 00:00:00Z],
                   end_datetime: ~N[2024-01-02 00:00:00]
                 )

        assert_received {:heart_rate_route_opts,
                         [
                           client: Client,
                           start_datetime: ~U[2024-01-01 00:00:00Z],
                           end_datetime: ~N[2024-01-02 00:00:00]
                         ]}
      end
    end

    test "returns date validation errors before delegation" do
      assert {:error, :invalid_end_date} =
               Client.call_api(
                 DailyActivityRoutes,
                 :multiple_daily_activity_documents_v2_usercollection_daily_activity_get,
                 [],
                 client: Client,
                 start_date: ~D[2024-01-01],
                 end_date: ~N[2024-01-02 00:00:00]
               )

      assert {:error, :end_date_before_start_date} =
               Client.call_api(
                 DailyActivityRoutes,
                 :multiple_daily_activity_documents_v2_usercollection_daily_activity_get,
                 [],
                 client: Client,
                 start_date: ~D[2024-01-02],
                 end_date: ~D[2024-01-01]
               )
    end
  end

  describe "set_auth_config/1" do
    test "reconfigures the running client state" do
      assert {:ok, _pid} = Client.start_link("access-token")

      auth_config = [
        access_token: "oauth-access-token",
        refresh_token: "refresh-token"
      ]

      assert :ok = Client.set_auth_config(auth_config)

      assert {:ok, token_info} = Client.get_token_info()
      assert token_info.access_token == "oauth-access-token"
      assert token_info.refresh_token == "refresh-token"
      assert token_info.auth_type == :oauth2
    end
  end

  describe "request/1" do
    test "performs GET requests with bearer auth and decodes successful responses" do
      assert {:ok, _pid} = Client.start_link("access-token")
      test_pid = self()

      operation = %{
        call: {DailyActivityRoutes, :multiple_daily_activity_documents_v2_usercollection_daily_activity_get},
        method: :get,
        query: [start_date: ~D[2024-01-01]],
        response: %{200 => :map},
        url: "/v2/usercollection/daily_activity"
      }

      with_mocks([
        {Req, [:passthrough],
         [
           get: fn "/v2/usercollection/daily_activity", opts ->
             send(test_pid, {:req_get_opts, opts})
             {:ok, %Req.Response{status: 200, body: %{data: [%{id: "row-1"}]}, headers: %{}}}
           end
         ]},
        {ExOura.TypeDecoder, [:passthrough],
         [
           decode_response: fn 200, %{data: [%{id: "row-1"}]}, ^operation ->
             {:ok, %{data: [%{id: "row-1"}]}}
           end
         ]}
      ]) do
        assert {:ok, %{data: [%{id: "row-1"}]}} = Client.request(operation)

        assert_received {:req_get_opts, opts}
        assert opts[:auth] == {:bearer, "access-token"}
        assert {"Authorization", "Bearer access-token"} in opts[:headers]
      end
    end

    test "returns :ok for 204 delete responses" do
      assert {:ok, _pid} = Client.start_link("access-token")

      operation = %{
        call:
          {WebhookSubscriptionRoutes, :delete_webhook_subscription_v2_webhook_subscription_webhook_subscription_id_delete},
        method: :delete,
        response: %{},
        url: "/v2/webhook/subscription/subscription-id"
      }

      with_mock Req, [:passthrough],
        delete: fn "/v2/webhook/subscription/subscription-id", _opts ->
          {:ok, %Req.Response{status: 204, body: nil, headers: %{}}}
        end do
        assert :ok = Client.request(operation)
      end
    end

    test "returns decoded validation errors for non-success responses" do
      assert {:ok, _pid} = Client.start_link("access-token")
      test_pid = self()

      operation = %{
        body: %{verification_token: nil},
        call: {WebhookSubscriptionRoutes, :create_webhook_subscription_v2_webhook_subscription_post},
        method: :post,
        response: %{422 => :map},
        url: "/v2/webhook/subscription"
      }

      System.put_env("OURA_CLIENT_ID", "client-id")
      System.put_env("OURA_CLIENT_SECRET", "client-secret")

      with_mocks([
        {Req, [:passthrough],
         [
           post: fn "/v2/webhook/subscription", opts ->
             send(test_pid, {:req_post_headers, opts[:headers]})
             {:ok, %Req.Response{status: 422, body: %{detail: "invalid payload"}, headers: %{}}}
           end
         ]},
        {ExOura.TypeDecoder, [:passthrough],
         [
           decode_response: fn 422, %{detail: "invalid payload"}, ^operation ->
             {:ok, %{detail: "invalid payload"}}
           end
         ]}
      ]) do
        assert {:error, %{detail: "invalid payload"}} = Client.request(operation)

        assert_received {:req_post_headers, headers}
        assert {"x-client-id", "client-id"} in headers
        assert {"x-client-secret", "client-secret"} in headers
      end
    end

    test "returns the raw body when error decoding fails" do
      assert {:ok, _pid} = Client.start_link("access-token")

      operation = %{
        body: %{verification_token: nil},
        call:
          {WebhookSubscriptionRoutes, :update_webhook_subscription_v2_webhook_subscription_webhook_subscription_id_put},
        method: :put,
        response: %{422 => :map},
        url: "/v2/webhook/subscription/subscription-id"
      }

      with_mocks([
        {Req, [:passthrough],
         [
           put: fn "/v2/webhook/subscription/subscription-id", _opts ->
             {:ok, %Req.Response{status: 422, body: %{detail: "raw error body"}, headers: %{}}}
           end
         ]},
        {ExOura.TypeDecoder, [:passthrough],
         [
           decode_response: fn 422, %{detail: "raw error body"}, ^operation ->
             {:error, :unable_to_decode}
           end
         ]}
      ]) do
        assert {:error, %{detail: "raw error body"}} = Client.request(operation)
      end
    end
  end

  defp restore_env(key, nil), do: System.delete_env(key)
  defp restore_env(key, value), do: System.put_env(key, value)
end
