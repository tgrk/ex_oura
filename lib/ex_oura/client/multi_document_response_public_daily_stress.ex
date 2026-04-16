defmodule ExOura.Client.MultiDocumentResponsePublicDailyStress do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicDailyStress
  """

  alias ExOura.Client.PublicDailyStress

  @type t :: %__MODULE__{
          data: [PublicDailyStress.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicDailyStress, :t}], next_token: {:union, [:string, :null]}]
  end
end
