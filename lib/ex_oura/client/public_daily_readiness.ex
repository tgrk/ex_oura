defmodule ExOura.Client.PublicDailyReadiness do
  @moduledoc """
  Provides struct and type for a PublicDailyReadiness
  """

  alias ExOura.Client.Metadata
  alias ExOura.Client.PublicReadinessContributors

  @type t :: %__MODULE__{
          contributors: PublicReadinessContributors.t(),
          day: String.t(),
          id: String.t(),
          meta: Metadata.t(),
          score: integer | nil,
          temperature_deviation: number | nil,
          temperature_trend_deviation: number | nil,
          timestamp: String.t()
        }

  defstruct [
    :contributors,
    :day,
    :id,
    :meta,
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
      contributors: {PublicReadinessContributors, :t},
      day: :string,
      id: :string,
      meta: {Metadata, :t},
      score: {:union, [:integer, :null]},
      temperature_deviation: {:union, [:number, :null]},
      temperature_trend_deviation: {:union, [:number, :null]},
      timestamp: :string
    ]
  end
end
