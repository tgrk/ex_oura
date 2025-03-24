defmodule ExOura.Client.DailyResilienceModel do
  @moduledoc """
  Provides struct and type for a DailyResilienceModel
  """

  alias ExOura.Client.DailyResilienceModelContributors
  alias ExOura.Client.DailyResilienceModelLevel

  @type t :: %__MODULE__{
          contributors: DailyResilienceModelContributors.t(),
          day: Date.t(),
          id: String.t(),
          level: DailyResilienceModelLevel.t()
        }

  defstruct [:contributors, :day, :id, :level]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      contributors: {DailyResilienceModelContributors, :t},
      day: {:string, :date},
      id: {:string, :generic},
      level: {DailyResilienceModelLevel, :t}
    ]
  end
end
