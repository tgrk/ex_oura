defmodule ExOura.Client.TimeSeriesResponsePublicRingBatteryLevelRow do
  @moduledoc """
  Provides struct and type for a TimeSeriesResponsePublicRingBatteryLevelRow
  """

  alias ExOura.Client.PublicRingBatteryLevelRow

  @type t :: %__MODULE__{
          data: [PublicRingBatteryLevelRow.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      data: [{PublicRingBatteryLevelRow, :t}],
      next_token: {:union, [:string, :null]}
    ]
  end
end
