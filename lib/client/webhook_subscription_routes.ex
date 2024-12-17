defmodule ExOura.Client.WebhookSubscriptionRoutes do
  @moduledoc """
  Provides API endpoints related to webhook subscription routes
  """

  @default_client ExOura.Client

  @doc """
  Create Webhook Subscription
  """
  @spec create_webhook_subscription_v2_webhook_subscription_post(
          ExOura.Client.CreateWebhookSubscriptionRequest.t(),
          keyword
        ) ::
          {:ok, ExOura.Client.WebhookSubscriptionModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def create_webhook_subscription_v2_webhook_subscription_post(body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [body: body],
      call:
        {ExOura.Client.WebhookSubscriptionRoutes,
         :create_webhook_subscription_v2_webhook_subscription_post},
      url: "/v2/webhook/subscription",
      body: body,
      method: :post,
      request: [{"application/json", {ExOura.Client.CreateWebhookSubscriptionRequest, :t}}],
      response: [
        {201, {ExOura.Client.WebhookSubscriptionModel, :t}},
        {422, {ExOura.Client.HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete Webhook Subscription
  """
  @spec delete_webhook_subscription_v2_webhook_subscription_id_delete(String.t(), keyword) ::
          :ok | {:error, ExOura.Client.HTTPValidationError.t()}
  def delete_webhook_subscription_v2_webhook_subscription_id_delete(id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [id: id],
      call:
        {ExOura.Client.WebhookSubscriptionRoutes,
         :delete_webhook_subscription_v2_webhook_subscription_id_delete},
      url: "/v2/webhook/subscription/#{id}",
      method: :delete,
      response: [{204, :null}, {403, :null}, {422, {ExOura.Client.HTTPValidationError, :t}}],
      opts: opts
    })
  end

  @doc """
  Get Webhook Subscription
  """
  @spec get_webhook_subscription_v2_webhook_subscription_id_get(String.t(), keyword) ::
          {:ok, ExOura.Client.WebhookSubscriptionModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def get_webhook_subscription_v2_webhook_subscription_id_get(id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [id: id],
      call:
        {ExOura.Client.WebhookSubscriptionRoutes,
         :get_webhook_subscription_v2_webhook_subscription_id_get},
      url: "/v2/webhook/subscription/#{id}",
      method: :get,
      response: [
        {200, {ExOura.Client.WebhookSubscriptionModel, :t}},
        {403, :null},
        {422, {ExOura.Client.HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List Webhook Subscriptions
  """
  @spec list_webhook_subscriptions_v2_webhook_subscription_get(keyword) ::
          {:ok, [ExOura.Client.WebhookSubscriptionModel.t()]} | :error
  def list_webhook_subscriptions_v2_webhook_subscription_get(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call:
        {ExOura.Client.WebhookSubscriptionRoutes,
         :list_webhook_subscriptions_v2_webhook_subscription_get},
      url: "/v2/webhook/subscription",
      method: :get,
      response: [{200, [{ExOura.Client.WebhookSubscriptionModel, :t}]}],
      opts: opts
    })
  end

  @doc """
  Renew Webhook Subscription
  """
  @spec renew_webhook_subscription_v2_webhook_subscription_renew_id_put(String.t(), keyword) ::
          {:ok, ExOura.Client.WebhookSubscriptionModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def renew_webhook_subscription_v2_webhook_subscription_renew_id_put(id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [id: id],
      call:
        {ExOura.Client.WebhookSubscriptionRoutes,
         :renew_webhook_subscription_v2_webhook_subscription_renew_id_put},
      url: "/v2/webhook/subscription/renew/#{id}",
      method: :put,
      response: [
        {200, {ExOura.Client.WebhookSubscriptionModel, :t}},
        {403, :null},
        {422, {ExOura.Client.HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Update Webhook Subscription
  """
  @spec update_webhook_subscription_v2_webhook_subscription_id_put(
          String.t(),
          ExOura.Client.UpdateWebhookSubscriptionRequest.t(),
          keyword
        ) ::
          {:ok, ExOura.Client.WebhookSubscriptionModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def update_webhook_subscription_v2_webhook_subscription_id_put(id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [id: id, body: body],
      call:
        {ExOura.Client.WebhookSubscriptionRoutes,
         :update_webhook_subscription_v2_webhook_subscription_id_put},
      url: "/v2/webhook/subscription/#{id}",
      body: body,
      method: :put,
      request: [{"application/json", {ExOura.Client.UpdateWebhookSubscriptionRequest, :t}}],
      response: [
        {200, {ExOura.Client.WebhookSubscriptionModel, :t}},
        {403, :null},
        {422, {ExOura.Client.HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end
end
