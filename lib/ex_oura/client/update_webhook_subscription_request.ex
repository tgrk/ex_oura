defmodule ExOura.Client.UpdateWebhookSubscriptionRequest do
  @moduledoc """
  Provides struct and type for a UpdateWebhookSubscriptionRequest
  """

  @type t :: %__MODULE__{
          callback_url: String.t() | nil,
          data_type: String.t() | nil,
          event_type: String.t() | nil,
          verification_token: String.t()
        }

  defstruct [:callback_url, :data_type, :event_type, :verification_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      callback_url: {:union, [{:string, :generic}, :null]},
      data_type:
        {:union,
         [
           {:enum,
            [
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
            ]},
           :null
         ]},
      event_type: {:union, [{:enum, ["create", "update", "delete"]}, :null]},
      verification_token: {:string, :generic}
    ]
  end
end
