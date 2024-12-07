defmodule ExOura.Client.ReadinessSummary do
  @moduledoc """
  Provides struct and type for a ReadinessSummary
  """

  @type t :: %__MODULE__{
          contributors: ExOura.Client.ReadinessContributors.t(),
          score: integer | nil,
          temperature_deviation: number | nil,
          temperature_trend_deviation: number | nil
        }

  defstruct [:contributors, :score, :temperature_deviation, :temperature_trend_deviation]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      contributors: {ExOura.Client.ReadinessContributors, :t},
      score: {:union, [:integer, :null]},
      temperature_deviation: {:union, [:number, :null]},
      temperature_trend_deviation: {:union, [:number, :null]}
    ]
  end
end
