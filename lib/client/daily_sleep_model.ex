defmodule ExOura.Client.DailySleepModel do
  @moduledoc """
  Provides struct and type for a DailySleepModel
  """

  @type t :: %__MODULE__{
          contributors: ExOura.Client.DailySleepModelContributors.t(),
          day: Date.t(),
          id: String.t(),
          score: integer | nil,
          timestamp: ExOura.Client.DailySleepModelTimestamp.t()
        }

  defstruct [:contributors, :day, :id, :score, :timestamp]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      contributors: {ExOura.Client.DailySleepModelContributors, :t},
      day: {:string, :date},
      id: {:string, :generic},
      score: {:union, [:integer, :null]},
      timestamp: {ExOura.Client.DailySleepModelTimestamp, :t}
    ]
  end
end