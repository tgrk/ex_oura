defmodule ExOura.Client.WebhookSubscriptionModel do
  @moduledoc """
  Provides struct and type for a WebhookSubscriptionModel
  """

  @type t :: %__MODULE__{
          callback_url: String.t(),
          data_type: String.t(),
          event_type: String.t(),
          expiration_time: DateTime.t(),
          id: String.t()
        }

  defstruct [:callback_url, :data_type, :event_type, :expiration_time, :id]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      callback_url: {:string, :generic},
      data_type:
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
           "daily_stress"
         ]},
      event_type: {:enum, ["create", "update", "delete"]},
      expiration_time: {:string, :date_time},
      id: {:string, :generic}
    ]
  end
end
