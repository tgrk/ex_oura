defmodule ExOura.OpenAPIContractTest do
  use ExUnit.Case, async: true

  alias ExOura.Client.CreateWebhookSubscriptionRequest
  alias ExOura.Client.UpdateWebhookSubscriptionRequest
  alias ExOura.Client.WebhookSubscriptionModel

  test "webhook subscription types expose the supported data types without meal" do
    expected_data_types = [
      "tag",
      "enhanced_tag",
      "workout",
      "session",
      "sleep",
      "daily_sleep",
      "daily_readiness",
      "daily_activity",
      "daily_spo2",
      "sleep_time",
      "rest_mode_period",
      "ring_configuration",
      "daily_stress",
      "daily_cardiovascular_age",
      "daily_resilience",
      "vo2_max"
    ]

    for module <- [CreateWebhookSubscriptionRequest, WebhookSubscriptionModel] do
      assert module.__fields__()[:data_type] == {:enum, expected_data_types}
    end

    assert UpdateWebhookSubscriptionRequest.__fields__()[:data_type] ==
             {:union, [{:enum, expected_data_types}, :null]}
  end
end
