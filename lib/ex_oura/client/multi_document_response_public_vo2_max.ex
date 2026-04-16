defmodule ExOura.Client.MultiDocumentResponsePublicVo2Max do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicVo2Max
  """

  alias ExOura.Client.PublicVo2Max

  @type t :: %__MODULE__{data: [PublicVo2Max.t()], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicVo2Max, :t}], next_token: {:union, [:string, :null]}]
  end
end
