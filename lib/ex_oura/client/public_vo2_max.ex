defmodule ExOura.Client.PublicVo2Max do
  @moduledoc """
  Provides struct and type for a PublicVo2Max
  """

  alias ExOura.Client.Metadata

  @type t :: %__MODULE__{
          day: String.t(),
          id: String.t(),
          meta: Metadata.t(),
          timestamp: String.t(),
          vo2_max: integer
        }

  defstruct [:day, :id, :meta, :timestamp, :vo2_max]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      day: :string,
      id: :string,
      meta: {Metadata, :t},
      timestamp: :string,
      vo2_max: :integer
    ]
  end
end
