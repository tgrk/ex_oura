defmodule ExOura.Client.MultiDocumentResponsePublicRestModePeriod do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicRestModePeriod
  """

  alias ExOura.Client.PublicRestModePeriod

  @type t :: %__MODULE__{
          data: [PublicRestModePeriod.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicRestModePeriod, :t}], next_token: {:union, [:string, :null]}]
  end
end
