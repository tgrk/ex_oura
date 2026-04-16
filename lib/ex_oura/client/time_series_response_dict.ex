defmodule ExOura.Client.TimeSeriesResponseDict do
  @moduledoc """
  Provides struct and type for a TimeSeriesResponseDict
  """

  @type t :: %__MODULE__{data: [map], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [:map], next_token: {:union, [:string, :null]}]
  end
end
