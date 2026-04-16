defmodule ExOura.Client.MultiDocumentResponsePublicModifiedSleepModel do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicModifiedSleepModel
  """

  alias ExOura.Client.PublicModifiedSleepModel

  @type t :: %__MODULE__{
          data: [PublicModifiedSleepModel.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicModifiedSleepModel, :t}], next_token: {:union, [:string, :null]}]
  end
end
