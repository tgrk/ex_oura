defmodule ExOura.Client.PublicRingConfiguration do
  @moduledoc """
  Provides struct and type for a PublicRingConfiguration
  """

  alias ExOura.Client.Metadata

  @type t :: %__MODULE__{
          color: String.t() | nil,
          design: String.t() | nil,
          firmware_version: String.t() | nil,
          hardware_type: String.t() | nil,
          id: String.t(),
          meta: Metadata.t(),
          set_up_at: String.t() | nil,
          size: integer | nil
        }

  defstruct [:color, :design, :firmware_version, :hardware_type, :id, :meta, :set_up_at, :size]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      color:
        {:union,
         [
           {:enum,
            [
              "brushed_silver",
              "glossy_black",
              "glossy_gold",
              "glossy_white",
              "gucci",
              "matt_gold",
              "rose",
              "silver",
              "stealth_black",
              "titanium",
              "titanium_and_gold",
              "cloud",
              "petal",
              "midnight",
              "tide"
            ]},
           :null
         ]},
      design: {:union, [{:enum, ["heritage", "balance", "balance_diamond", "horizon", "ceramic"]}, :null]},
      firmware_version: {:union, [:string, :null]},
      hardware_type: {:union, [{:enum, ["gen1", "gen2", "gen2m", "gen3", "gen4"]}, :null]},
      id: :string,
      meta: {Metadata, :t},
      set_up_at: {:union, [:string, :null]},
      size: {:union, [:integer, :null]}
    ]
  end
end
