defmodule ExOura.Client.PublicRingBatteryLevelRow do
  @moduledoc """
  Provides struct and type for a PublicRingBatteryLevelRow
  """

  @type t :: %__MODULE__{
          charging: boolean | nil,
          in_charger: boolean | nil,
          level: integer,
          timestamp: String.t(),
          timestamp_unix: integer
        }

  defstruct [:charging, :in_charger, :level, :timestamp, :timestamp_unix]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      charging: {:union, [:boolean, :null]},
      in_charger: {:union, [:boolean, :null]},
      level: :integer,
      timestamp: :string,
      timestamp_unix: :integer
    ]
  end
end
