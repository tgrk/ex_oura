defmodule ExOura.Client.DailyResilienceModel do
  @moduledoc """
  Provides struct and type for a DailyResilienceModel
  """

  @type t :: %__MODULE__{
          contributors: ExOura.Client.DailyResilienceModelContributors.t(),
          day: Date.t(),
          id: String.t(),
          level: ExOura.Client.DailyResilienceModelLevel.t()
        }

  defstruct [:contributors, :day, :id, :level]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      contributors: {ExOura.Client.DailyResilienceModelContributors, :t},
      day: {:string, :date},
      id: {:string, :generic},
      level: {ExOura.Client.DailyResilienceModelLevel, :t}
    ]
  end
end
