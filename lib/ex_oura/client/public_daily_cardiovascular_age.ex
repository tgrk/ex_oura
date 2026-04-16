defmodule ExOura.Client.PublicDailyCardiovascularAge do
  @moduledoc """
  Provides struct and type for a PublicDailyCardiovascularAge
  """

  alias ExOura.Client.Metadata

  @type t :: %__MODULE__{
          day: String.t(),
          id: String.t(),
          meta: Metadata.t(),
          vascular_age: integer | nil
        }

  defstruct [:day, :id, :meta, :vascular_age]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      day: :string,
      id: :string,
      meta: {Metadata, :t},
      vascular_age: {:union, [:integer, :null]}
    ]
  end
end
