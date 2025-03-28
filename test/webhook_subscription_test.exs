defmodule ExOura.WebhookSubscriptionTest do
  use ExOura.Test.Support.Case, async: false

  import Mock

  alias ExOura.Client.CreateWebhookSubscriptionRequest
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.WebhookSubscriptionModel

  describe "Webhook Subscription - list_webhook_subscription/1" do
    test "should return webhook subscriptions" do
      with_mock Req, get: successful_response(:list_webhook_subscription, 200) do
        assert {:ok, [%WebhookSubscriptionModel{}]} =
                 ExOura.list_webhook_subscriptions()
      end
    end

    test "should return empty list when listing webhook subscriptions" do
      assert {:ok, []} = ExOura.list_webhook_subscriptions()
    end
  end

  describe "Webhook Subscription - create_webhook_subscription/2" do
    test "should successfully create a webhook subscription" do
      with_mock Req, post: successful_response(:create_webhook_subscription, 201) do
        webhook = %CreateWebhookSubscriptionRequest{
          callback_url: "http://example.com",
          data_type: "tag",
          event_type: "create",
          verification_token: "foobar"
        }

        assert {:ok, %WebhookSubscriptionModel{}} =
                 ExOura.create_webhook_subscription(webhook)
      end
    end

    test "should fail when create a webhook subscription with invalid payload" do
      webhook = %CreateWebhookSubscriptionRequest{
        callback_url: "http://example.com",
        data_type: "foo",
        event_type: "create",
        verification_token: "foobar"
      }

      assert {:error,
              %HTTPValidationError{
                detail: [
                  %{
                    type: "enum",
                    msg:
                      "Input should be 'tag', 'enhanced_tag', 'workout', 'session', 'sleep', 'daily_sleep', 'daily_readiness', 'daily_activity', 'daily_spo2', 'sleep_time', 'rest_mode_period', 'ring_configuration', 'daily_stress', 'daily_cycle_phases', 'activation_status', 'daily_cardiovascular_age', 'daily_resilience' or 'vo2_max'",
                    loc: ["body", "data_type"]
                  }
                ]
              }} = ExOura.create_webhook_subscription(webhook)
    end
  end

  describe "Webhook Subscription - delete_webhook_subscription/2" do
    test "should delete a webhook subscription" do
      with_mock Req, delete: successful_response(:delete_webhook_subscription, 204) do
        assert :ok =
                 ExOura.delete_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bfd")
      end
    end

    test "should fail when deleting a webhook subscription ID does not exists" do
      assert {:error, %{detail: "No webhook id c534043e-ba54-4131-9dce-e40537823bff found."}} =
               ExOura.delete_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bff")
    end
  end

  describe "Webhook Subscription - get_webhook_subscription/2" do
    test "should return a webhook subscription" do
      with_mock Req, get: successful_response(:get_webhook_subscription, 200) do
        assert {:ok, %WebhookSubscriptionModel{}} =
                 ExOura.get_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bfd")
      end
    end

    test "should fail when getting a webhook subscription ID does not exists" do
      assert {:error, %{detail: "Forbidden"}} =
               ExOura.get_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bff")
    end
  end

  describe "Webhook Subscription - update_webhook_subscription/2" do
    test "should return an updated webhook subscription" do
      with_mock Req, put: successful_response(:update_webhook_subscription, 200) do
        webhook = %CreateWebhookSubscriptionRequest{
          callback_url: "http://example.com",
          data_type: "foo",
          event_type: "create",
          verification_token: "foobar"
        }

        assert {:ok, %WebhookSubscriptionModel{}} =
                 ExOura.update_webhook_subscription(
                   "c534043e-ba54-4131-9dce-e40537823bfd",
                   webhook
                 )
      end
    end

    test "should fail when updating a webhook with an invalid payload" do
      webhook = %CreateWebhookSubscriptionRequest{
        callback_url: "http://example.com",
        data_type: "tag",
        event_type: "create"
      }

      assert {
               :error,
               %HTTPValidationError{
                 detail: [
                   %{
                     type: "string_type",
                     msg: "Input should be a valid string",
                     loc: ["body", "verification_token"]
                   }
                 ]
               }
             } =
               ExOura.update_webhook_subscription(
                 "c534043e-ba54-4131-9dce-e40537823bff",
                 webhook
               )
    end

    test "should fail when updating a webhook subscription ID does not exists" do
      webhook = %CreateWebhookSubscriptionRequest{
        callback_url: "http://example.com",
        data_type: "tag",
        event_type: "create",
        verification_token: "foobar"
      }

      assert {:error, %{detail: "Subscription with id c534043e-ba54-4131-9dce-e40537823bff not found."}} =
               ExOura.update_webhook_subscription(
                 "c534043e-ba54-4131-9dce-e40537823bff",
                 webhook
               )
    end
  end

  describe "Webhook Subscription - renew_webhook_subscription/2" do
    test "should return a renewed webhook subscription" do
      with_mock Req, put: successful_response(:renew_webhook_subscription, 200) do
        assert {:ok, %WebhookSubscriptionModel{}} =
                 ExOura.renew_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bfd")
      end
    end

    test "should fail when renewing a webhook subscription ID does not exists" do
      assert {:error, %{detail: "Subscription with id c534043e-ba54-4131-9dce-e40537823bff not found."}} =
               ExOura.renew_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bff")
    end
  end

  defp successful_response(_operation, 204 = status) do
    fn _url, opts ->
      if valid_headers?(opts) do
        {:ok, %Req.Response{status: status}}
      else
        {:error, :invalid_webhook_headers}
      end
    end
  end

  defp successful_response(operation, status) do
    fn _url, opts ->
      if valid_headers?(opts) do
        {:ok, %Req.Response{status: status, body: load_mock_fixture(operation)}}
      else
        {:error, :invalid_webhook_headers}
      end
    end
  end

  defp valid_headers?(opts) do
    headers = opts |> Keyword.get(:headers) |> Map.new()
    Map.has_key?(headers, "x-client-id") && Map.has_key?(headers, "x-client-secret")
  end

  defp load_mock_fixture(operation) do
    path = Path.expand("fixture/mock/#{operation}.json", __DIR__)
    path |> File.read!() |> Jason.decode!()
  end
end
