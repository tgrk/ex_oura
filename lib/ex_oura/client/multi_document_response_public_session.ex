defmodule ExOura.Client.MultiDocumentResponsePublicSession do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicSession
  """

  alias ExOura.Client.PublicSession

  @type t :: %__MODULE__{data: [PublicSession.t()], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicSession, :t}], next_token: {:union, [:string, :null]}]
  end
end
