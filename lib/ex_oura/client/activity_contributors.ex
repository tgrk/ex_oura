defmodule ExOura.Client.ActivityContributors do
  @moduledoc false
  @type t :: %__MODULE__{
          meet_daily_targets: integer | nil,
          move_every_hour: integer | nil,
          recovery_time: integer | nil,
          stay_active: integer | nil,
          training_frequency: integer | nil,
          training_volume: integer | nil
        }

  defstruct [
    :meet_daily_targets,
    :move_every_hour,
    :recovery_time,
    :stay_active,
    :training_frequency,
    :training_volume
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      meet_daily_targets: {:union, [:integer, :null]},
      move_every_hour: {:union, [:integer, :null]},
      recovery_time: {:union, [:integer, :null]},
      stay_active: {:union, [:integer, :null]},
      training_frequency: {:union, [:integer, :null]},
      training_volume: {:union, [:integer, :null]}
    ]
  end
end
