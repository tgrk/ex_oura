defmodule ExOura.Client.TimeSeriesResponsePublicHeartRateRow do
  @moduledoc """
  Provides struct and type for a TimeSeriesResponsePublicHeartRateRow
  """

  alias ExOura.Client.PublicHeartRateRow

  @type t :: %__MODULE__{
          data: [PublicHeartRateRow.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicHeartRateRow, :t}], next_token: {:union, [:string, :null]}]
  end
end
