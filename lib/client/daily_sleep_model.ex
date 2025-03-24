defmodule ExOura.Client.DailySleepModel do
  @moduledoc """
  Provides struct and type for a DailySleepModel
  """

  alias ExOura.Client.DailySleepModelContributors
  alias ExOura.Client.DailySleepModelTimestamp

  @type t :: %__MODULE__{
          contributors: DailySleepModelContributors.t(),
          day: Date.t(),
          id: String.t(),
          score: integer | nil,
          timestamp: DailySleepModelTimestamp.t()
        }

  defstruct [:contributors, :day, :id, :score, :timestamp]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      contributors: {DailySleepModelContributors, :t},
      day: {:string, :date},
      id: {:string, :generic},
      score: {:union, [:integer, :null]},
      timestamp: {DailySleepModelTimestamp, :t}
    ]
  end
end
