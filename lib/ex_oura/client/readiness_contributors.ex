defmodule ExOura.Client.ReadinessContributors do
  @moduledoc false
  @type t :: %__MODULE__{
          activity_balance: integer | nil,
          body_temperature: integer | nil,
          hrv_balance: integer | nil,
          previous_day_activity: integer | nil,
          previous_night: integer | nil,
          recovery_index: integer | nil,
          resting_heart_rate: integer | nil,
          sleep_balance: integer | nil
        }

  defstruct [
    :activity_balance,
    :body_temperature,
    :hrv_balance,
    :previous_day_activity,
    :previous_night,
    :recovery_index,
    :resting_heart_rate,
    :sleep_balance
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      activity_balance: {:union, [:integer, :null]},
      body_temperature: {:union, [:integer, :null]},
      hrv_balance: {:union, [:integer, :null]},
      previous_day_activity: {:union, [:integer, :null]},
      previous_night: {:union, [:integer, :null]},
      recovery_index: {:union, [:integer, :null]},
      resting_heart_rate: {:union, [:integer, :null]},
      sleep_balance: {:union, [:integer, :null]}
    ]
  end
end
