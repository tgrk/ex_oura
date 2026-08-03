defmodule ExOura.Client.PublicVo2Max do
  @moduledoc """
  Provides struct and type for a PublicVo2Max
  """

  @type t :: %__MODULE__{day: String.t(), id: String.t(), timestamp: String.t(), vo2_max: integer}

  defstruct [:day, :id, :timestamp, :vo2_max]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [day: :string, id: :string, timestamp: :string, vo2_max: :integer]
  end
end
