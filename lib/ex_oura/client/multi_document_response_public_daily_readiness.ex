defmodule ExOura.Client.MultiDocumentResponsePublicDailyReadiness do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicDailyReadiness
  """

  alias ExOura.Client.PublicDailyReadiness

  @type t :: %__MODULE__{
          data: [PublicDailyReadiness.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicDailyReadiness, :t}], next_token: {:union, [:string, :null]}]
  end
end
