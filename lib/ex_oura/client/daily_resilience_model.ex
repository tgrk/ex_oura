defmodule ExOura.Client.DailyResilienceModel do
  @moduledoc """
  Provides struct and type for a DailyResilienceModel
  """

  alias ExOura.Client.ResilienceContributors

  @type t :: %__MODULE__{
          contributors: ResilienceContributors.t(),
          day: Date.t(),
          id: String.t(),
          level: String.t()
        }

  defstruct [:contributors, :day, :id, :level]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      contributors: {ResilienceContributors, :t},
      day: {:string, :date},
      id: {:string, :generic},
      level: {:enum, ["limited", "adequate", "solid", "strong", "exceptional"]}
    ]
  end
end
