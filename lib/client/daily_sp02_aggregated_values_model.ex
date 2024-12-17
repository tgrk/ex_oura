defmodule ExOura.Client.DailySpO2AggregatedValuesModel do
  @moduledoc """
  Provides struct and type for a DailySpO2AggregatedValuesModel
  """

  @type t :: %__MODULE__{average: number}

  defstruct [:average]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [average: :number]
  end
end
