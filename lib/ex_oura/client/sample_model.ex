defmodule ExOura.Client.SampleModel do
  @moduledoc """
  Provides struct and type for a SampleModel
  """

  @type t :: %__MODULE__{interval: number, items: [number | nil], timestamp: String.t()}

  defstruct [:interval, :items, :timestamp]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [interval: :number, items: [union: [:number, :null]], timestamp: {:string, :generic}]
  end
end
