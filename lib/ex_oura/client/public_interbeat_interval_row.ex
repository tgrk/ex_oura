defmodule ExOura.Client.PublicInterbeatIntervalRow do
  @moduledoc """
  Provides struct and type for a PublicInterbeatIntervalRow
  """

  @type t :: %__MODULE__{
          ibi: integer,
          timestamp: String.t(),
          timestamp_unix: integer,
          validity: integer
        }

  defstruct [:ibi, :timestamp, :timestamp_unix, :validity]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [ibi: :integer, timestamp: :string, timestamp_unix: :integer, validity: :integer]
  end
end
