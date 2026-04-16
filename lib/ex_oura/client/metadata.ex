defmodule ExOura.Client.Metadata do
  @moduledoc """
  Provides struct and type for a Metadata
  """

  @type t :: %__MODULE__{updated_at: String.t(), version: integer}

  defstruct [:updated_at, :version]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [updated_at: :string, version: :integer]
  end
end
