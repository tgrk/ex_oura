defmodule ExOura.Client.MultiDocumentResponsePublicDailyCardiovascularAge do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicDailyCardiovascularAge
  """

  alias ExOura.Client.PublicDailyCardiovascularAge

  @type t :: %__MODULE__{
          data: [PublicDailyCardiovascularAge.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      data: [{PublicDailyCardiovascularAge, :t}],
      next_token: {:union, [:string, :null]}
    ]
  end
end
