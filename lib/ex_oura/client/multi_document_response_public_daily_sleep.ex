defmodule ExOura.Client.MultiDocumentResponsePublicDailySleep do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicDailySleep
  """

  alias ExOura.Client.PublicDailySleep

  @type t :: %__MODULE__{data: [PublicDailySleep.t()], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicDailySleep, :t}], next_token: {:union, [:string, :null]}]
  end
end
