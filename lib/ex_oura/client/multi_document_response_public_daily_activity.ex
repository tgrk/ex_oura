defmodule ExOura.Client.MultiDocumentResponsePublicDailyActivity do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicDailyActivity
  """

  alias ExOura.Client.PublicDailyActivity

  @type t :: %__MODULE__{
          data: [PublicDailyActivity.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicDailyActivity, :t}], next_token: {:union, [:string, :null]}]
  end
end
