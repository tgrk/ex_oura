defmodule ExOura.WebhookSubscriptionTest do
  use ExOura.Test.Support.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias ExOura.Client.CreateWebhookSubscriptionRequest
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.WebhookSubscriptionModel

  describe "Webhook Subscription - list_webhook_subscription/1" do
    test "should return webhook subscriptions" do
      use_cassette "list_webhook_subscription" do
        assert {:ok, [%WebhookSubscriptionModel{}]} =
                 ExOura.list_webhook_subscriptions()
      end
    end

    test "should return empty list when listing webhook subscriptions" do
      use_cassette "list_webhook_subscription_empty" do
        assert {:ok, []} = ExOura.list_webhook_subscriptions()
      end
    end
  end

  describe "Webhook Subscription - create_webhook_subscription/2" do
    test "should successfully create a webhook subscription" do
      use_cassette "create_webhook_subscription" do
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
      use_cassette "create_webhook_subscription_invalid" do
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
                      msg: "Invalid data_type value",
                      loc: ["body", "data_type"]
                    }
                  ]
                }} = ExOura.create_webhook_subscription(webhook)
      end
    end
  end

  describe "Webhook Subscription - delete_webhook_subscription/2" do
    test "should delete a webhook subscription" do
      use_cassette "delete_webhook_subscription" do
        assert :ok =
                 ExOura.delete_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bfd")
      end
    end

    test "should fail when deleting a webhook subscription ID does not exists" do
      use_cassette "delete_webhook_subscription_not_found" do
        assert {:error, %{detail: "No webhook id c534043e-ba54-4131-9dce-e40537823bff found."}} =
                 ExOura.delete_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bff")
      end
    end
  end

  describe "Webhook Subscription - get_webhook_subscription/2" do
    test "should return a webhook subscription" do
      use_cassette "get_webhook_subscription" do
        assert {:ok, %WebhookSubscriptionModel{}} =
                 ExOura.get_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bfd")
      end
    end

    test "should fail when getting a webhook subscription ID does not exists" do
      use_cassette "get_webhook_subscription_forbidden" do
        assert {:error, %{detail: "Forbidden"}} =
                 ExOura.get_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bff")
      end
    end
  end

  describe "Webhook Subscription - update_webhook_subscription/2" do
    test "should return an updated webhook subscription" do
      use_cassette "update_webhook_subscription" do
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
      use_cassette "update_webhook_subscription_invalid" do
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
                       msg: "verification_token is required",
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
    end

    test "should fail when updating a webhook subscription ID does not exists" do
      use_cassette "update_webhook_subscription_not_found" do
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
  end

  describe "Webhook Subscription - renew_webhook_subscription/2" do
    test "should return a renewed webhook subscription" do
      use_cassette "renew_webhook_subscription" do
        assert {:ok, %WebhookSubscriptionModel{}} =
                 ExOura.renew_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bfd")
      end
    end

    test "should fail when renewing a webhook subscription ID does not exists" do
      use_cassette "renew_webhook_subscription_not_found" do
        assert {:error, %{detail: "Subscription with id c534043e-ba54-4131-9dce-e40537823bff not found."}} =
                 ExOura.renew_webhook_subscription("c534043e-ba54-4131-9dce-e40537823bff")
      end
    end
  end
end
