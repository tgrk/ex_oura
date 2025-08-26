defmodule ExOura.Client.WorkoutModel do
  @moduledoc false
  alias ExOura.Client.WorkoutModelEndDatetime
  alias ExOura.Client.WorkoutModelSource
  alias ExOura.Client.WorkoutModelStartDatetime

  @type t :: %__MODULE__{
          activity: String.t(),
          calories: number | nil,
          day: Date.t(),
          distance: number | nil,
          end_datetime: WorkoutModelEndDatetime.t(),
          id: String.t(),
          intensity: String.t(),
          label: String.t() | nil,
          source: WorkoutModelSource.t(),
          start_datetime: WorkoutModelStartDatetime.t()
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
      day: {:string, :date},
      distance: {:union, [:number, :null]},
      end_datetime: {WorkoutModelEndDatetime, :t},
      id: {:string, :generic},
      intensity: {:enum, ["easy", "moderate", "hard"]},
      label: {:union, [{:string, :generic}, :null]},
      source: {WorkoutModelSource, :t},
      start_datetime: {WorkoutModelStartDatetime, :t}
    ]
  end
end
