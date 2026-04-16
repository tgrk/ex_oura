defmodule ExOura.Client.PublicSpo2AggregatedValues do
  @moduledoc """
  Provides struct and type for a PublicSpo2AggregatedValues
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
