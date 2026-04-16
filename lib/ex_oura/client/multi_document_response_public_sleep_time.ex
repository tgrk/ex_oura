defmodule ExOura.Client.MultiDocumentResponsePublicSleepTime do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicSleepTime
  """

  alias ExOura.Client.PublicSleepTime

  @type t :: %__MODULE__{data: [PublicSleepTime.t()], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicSleepTime, :t}], next_token: {:union, [:string, :null]}]
  end
end
