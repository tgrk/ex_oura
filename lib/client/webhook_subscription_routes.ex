defmodule ExOura.Client.WebhookSubscriptionRoutes do
  @moduledoc """
  Provides API endpoints related to webhook subscription routes
  """

  alias ExOura.Client.CreateWebhookSubscriptionRequest
  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.UpdateWebhookSubscriptionRequest
  alias ExOura.Client.WebhookSubscriptionModel
  alias ExOura.Client.WebhookSubscriptionRoutes

  @default_client ExOura.Client

  @doc """
  Create Webhook Subscription
  """
  @spec create_webhook_subscription_v2_webhook_subscription_post(
          CreateWebhookSubscriptionRequest.t(),
          keyword
        ) ::
          {:ok, WebhookSubscriptionModel.t()}
          | {:error, HTTPValidationError.t()}
  def create_webhook_subscription_v2_webhook_subscription_post(body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [body: body],
      call: {WebhookSubscriptionRoutes, :create_webhook_subscription_v2_webhook_subscription_post},
      url: "/v2/webhook/subscription",
      body: body,
      method: :post,
      request: [{"application/json", {CreateWebhookSubscriptionRequest, :t}}],
      response: [
        {201, {WebhookSubscriptionModel, :t}},
        {422, {HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Delete Webhook Subscription
  """
  @spec delete_webhook_subscription_v2_webhook_subscription_id_delete(String.t(), keyword) ::
          :ok | {:error, HTTPValidationError.t()}
  def delete_webhook_subscription_v2_webhook_subscription_id_delete(id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [id: id],
      call: {WebhookSubscriptionRoutes, :delete_webhook_subscription_v2_webhook_subscription_id_delete},
      url: "/v2/webhook/subscription/#{id}",
      method: :delete,
      response: [{204, :null}, {403, :null}, {422, {HTTPValidationError, :t}}],
      opts: opts
    })
  end

  @doc """
  Get Webhook Subscription
  """
  @spec get_webhook_subscription_v2_webhook_subscription_id_get(String.t(), keyword) ::
          {:ok, WebhookSubscriptionModel.t()}
          | {:error, HTTPValidationError.t()}
  def get_webhook_subscription_v2_webhook_subscription_id_get(id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [id: id],
      call: {WebhookSubscriptionRoutes, :get_webhook_subscription_v2_webhook_subscription_id_get},
      url: "/v2/webhook/subscription/#{id}",
      method: :get,
      response: [
        {200, {WebhookSubscriptionModel, :t}},
        {403, :null},
        {422, {HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  List Webhook Subscriptions
  """
  @spec list_webhook_subscriptions_v2_webhook_subscription_get(keyword) ::
          {:ok, [WebhookSubscriptionModel.t()]} | :error
  def list_webhook_subscriptions_v2_webhook_subscription_get(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {WebhookSubscriptionRoutes, :list_webhook_subscriptions_v2_webhook_subscription_get},
      url: "/v2/webhook/subscription",
      method: :get,
      response: [{200, [{WebhookSubscriptionModel, :t}]}],
      opts: opts
    })
  end

  @doc """
  Renew Webhook Subscription
  """
  @spec renew_webhook_subscription_v2_webhook_subscription_renew_id_put(String.t(), keyword) ::
          {:ok, WebhookSubscriptionModel.t()}
          | {:error, HTTPValidationError.t()}
  def renew_webhook_subscription_v2_webhook_subscription_renew_id_put(id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [id: id],
      call: {WebhookSubscriptionRoutes, :renew_webhook_subscription_v2_webhook_subscription_renew_id_put},
      url: "/v2/webhook/subscription/renew/#{id}",
      method: :put,
      response: [
        {200, {WebhookSubscriptionModel, :t}},
        {403, :null},
        {422, {HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Update Webhook Subscription
  """
  @spec update_webhook_subscription_v2_webhook_subscription_id_put(
          String.t(),
          UpdateWebhookSubscriptionRequest.t(),
          keyword
        ) ::
          {:ok, WebhookSubscriptionModel.t()}
          | {:error, HTTPValidationError.t()}
  def update_webhook_subscription_v2_webhook_subscription_id_put(id, body, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [id: id, body: body],
      call: {WebhookSubscriptionRoutes, :update_webhook_subscription_v2_webhook_subscription_id_put},
      url: "/v2/webhook/subscription/#{id}",
      body: body,
      method: :put,
      request: [{"application/json", {UpdateWebhookSubscriptionRequest, :t}}],
      response: [
        {200, {WebhookSubscriptionModel, :t}},
        {403, :null},
        {422, {HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end
end
