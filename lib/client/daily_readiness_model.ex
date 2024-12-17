defmodule ExOura.Client.DailyReadinessModel do
  @moduledoc """
  Provides struct and type for a DailyReadinessModel
  """

  @type t :: %__MODULE__{
          contributors: ExOura.Client.DailyReadinessModelContributors.t(),
          day: Date.t(),
          id: String.t(),
          score: integer | nil,
          temperature_deviation: number | nil,
          temperature_trend_deviation: number | nil,
          timestamp: ExOura.Client.DailyReadinessModelTimestamp.t()
        }

  defstruct [
    :contributors,
    :day,
    :id,
    :score,
    :temperature_deviation,
    :temperature_trend_deviation,
    :timestamp
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      contributors: {ExOura.Client.DailyReadinessModelContributors, :t},
      day: {:string, :date},
      id: {:string, :generic},
      score: {:union, [:integer, :null]},
      temperature_deviation: {:union, [:number, :null]},
      temperature_trend_deviation: {:union, [:number, :null]},
      timestamp: {ExOura.Client.DailyReadinessModelTimestamp, :t}
    ]
  end
end
