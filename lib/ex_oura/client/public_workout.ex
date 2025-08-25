defmodule ExOura.Client.PublicWorkout do
  @moduledoc """
  Provides struct and type for a PublicWorkout
  """

  @type t :: %__MODULE__{
          activity: String.t(),
          calories: number | nil,
          day: String.t(),
          distance: number | nil,
          end_datetime: String.t(),
          id: String.t(),
          intensity: String.t(),
          label: String.t() | nil,
          source: String.t(),
          start_datetime: String.t()
        }

  defstruct [
    :activity,
    :calories,
    :day,
    :distance,
    :end_datetime,
    :id,
    :intensity,
    :label,
    :source,
    :start_datetime
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      activity: {:string, :generic},
      calories: {:union, [:number, :null]},
      day: {:string, :generic},
      distance: {:union, [:number, :null]},
      end_datetime: {:string, :generic},
      id: {:string, :generic},
      intensity: {:enum, ["easy", "moderate", "hard"]},
      label: {:union, [{:string, :generic}, :null]},
      source: {:enum, ["manual", "autodetected", "confirmed", "workout_heart_rate"]},
      start_datetime: {:string, :generic}
    ]
  end
end
