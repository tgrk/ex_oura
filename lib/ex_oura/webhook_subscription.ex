defmodule ExOura.WebhookSubscription do
  @moduledoc """
  Documentation for Oura API - Webhook Subscription
  """

  alias ExOura.Client

  @doc """
  Create Webhook Subscription
  """
  def create_webhook_subscription(webhook, opts \\ []) do
    Client.call_api(
      Client.WebhookSubscriptionRoutes,
      :create_webhook_subscription_v2_webhook_subscription_post,
      [webhook |> Map.from_struct() |> Jason.encode!()],
      opts
    )
  end

  @doc """
  Delete Webhook Subscription
  """
  def delete_webhook_subscription(webhook_id, opts \\ []) do
    Client.call_api(
      Client.WebhookSubscriptionRoutes,
      :delete_webhook_subscription_v2_webhook_subscription_id_delete,
      [webhook_id],
      opts
    )
  end

  @doc """
  Get Webhook Subscription
  """
  def get_webhook_subscription(webhook_id, opts \\ []) do
    Client.call_api(
      Client.WebhookSubscriptionRoutes,
      :get_webhook_subscription_v2_webhook_subscription_id_get,
      [webhook_id],
      opts
    )
  end

  @doc """
  List Webhook Subscription
  """
  def list_webhook_subscriptions(opts \\ []) do
    Client.call_api(
      Client.WebhookSubscriptionRoutes,
      :list_webhook_subscriptions_v2_webhook_subscription_get,
      [],
      opts
    )
  end

  @doc """
  Renew Webhook Subscription
  """
  def renew_webhook_subscription(webhook_id, opts \\ []) do
    Client.call_api(
      Client.WebhookSubscriptionRoutes,
      :renew_webhook_subscription_v2_webhook_subscription_renew_id_put,
      [webhook_id],
      opts
    )
  end

  @doc """
  Update Webhook Subscription
  """
  def update_webhook_subscription(webhook_id, webhook, opts \\ []) do
    Client.call_api(
      Client.WebhookSubscriptionRoutes,
      :update_webhook_subscription_v2_webhook_subscription_id_put,
      [webhook_id, webhook |> Map.from_struct() |> Jason.encode!()],
      opts
    )
  end
end
