defmodule ExOura.Client.PublicWorkout do
  @moduledoc """
  Provides struct and type for a PublicWorkout
  """

  alias ExOura.Client.Metadata

  @type t :: %__MODULE__{
          activity: String.t(),
          calories: number | nil,
          day: String.t(),
          distance: number | nil,
          end_datetime: String.t(),
          id: String.t(),
          intensity: String.t(),
          label: String.t() | nil,
          meta: Metadata.t(),
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
    :meta,
    :source,
    :start_datetime
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      activity: :string,
      calories: {:union, [:number, :null]},
      day: :string,
      distance: {:union, [:number, :null]},
      end_datetime: :string,
      id: :string,
      intensity: {:enum, ["easy", "moderate", "hard"]},
      label: {:union, [:string, :null]},
      meta: {Metadata, :t},
      source: {:enum, ["manual", "autodetected", "confirmed", "workout_heart_rate"]},
      start_datetime: :string
    ]
  end
end
