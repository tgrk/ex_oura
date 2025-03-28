defmodule ExOura.Client.DailyReadinessModel do
  @moduledoc """
  Provides struct and type for a DailyReadinessModel
  """

  alias ExOura.Client.DailyReadinessModelContributors
  alias ExOura.Client.DailyReadinessModelTimestamp

  @type t :: %__MODULE__{
          contributors: DailyReadinessModelContributors.t(),
          day: Date.t(),
          id: String.t(),
          score: integer | nil,
          temperature_deviation: number | nil,
          temperature_trend_deviation: number | nil,
          timestamp: DailyReadinessModelTimestamp.t()
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
      contributors: {DailyReadinessModelContributors, :t},
      day: {:string, :date},
      id: {:string, :generic},
      score: {:union, [:integer, :null]},
      temperature_deviation: {:union, [:number, :null]},
      temperature_trend_deviation: {:union, [:number, :null]},
      timestamp: {DailyReadinessModelTimestamp, :t}
    ]
  end
end
