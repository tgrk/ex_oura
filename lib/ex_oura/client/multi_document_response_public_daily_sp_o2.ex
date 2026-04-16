defmodule ExOura.Client.MultiDocumentResponsePublicDailySpO2 do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicDailySpO2
  """

  alias ExOura.Client.PublicDailySpO2

  @type t :: %__MODULE__{data: [PublicDailySpO2.t()], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicDailySpO2, :t}], next_token: {:union, [:string, :null]}]
  end
end
