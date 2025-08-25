defmodule ExOura.Client.DailySleepModel do
  @moduledoc false
  alias ExOura.Client.SleepContributors

  @type t :: %__MODULE__{
          contributors: SleepContributors.t(),
          day: Date.t(),
          id: String.t(),
          score: integer | nil,
          timestamp: String.t()
        }

  defstruct [:contributors, :day, :id, :score, :timestamp]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      contributors: {SleepContributors, :t},
      day: {:string, :date},
      id: {:string, :generic},
      score: {:union, [:integer, :null]},
      timestamp: {:string, :generic}
    ]
  end
end
