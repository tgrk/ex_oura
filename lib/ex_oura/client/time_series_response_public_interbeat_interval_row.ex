defmodule ExOura.Client.TimeSeriesResponsePublicInterbeatIntervalRow do
  @moduledoc """
  Provides struct and type for a TimeSeriesResponsePublicInterbeatIntervalRow
  """

  alias ExOura.Client.PublicInterbeatIntervalRow

  @type t :: %__MODULE__{
          data: [PublicInterbeatIntervalRow.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      data: [{PublicInterbeatIntervalRow, :t}],
      next_token: {:union, [:string, :null]}
    ]
  end
end
