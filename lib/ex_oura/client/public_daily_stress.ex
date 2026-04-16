defmodule ExOura.Client.PublicDailyStress do
  @moduledoc """
  Provides struct and type for a PublicDailyStress
  """

  alias ExOura.Client.Metadata

  @type t :: %__MODULE__{
          day: String.t(),
          day_summary: String.t() | nil,
          id: String.t(),
          meta: Metadata.t(),
          recovery_high: integer | nil,
          stress_high: integer | nil
        }

  defstruct [:day, :day_summary, :id, :meta, :recovery_high, :stress_high]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      day: :string,
      day_summary: {:union, [{:enum, ["restored", "normal", "stressful"]}, :null]},
      id: :string,
      meta: {Metadata, :t},
      recovery_high: {:union, [:integer, :null]},
      stress_high: {:union, [:integer, :null]}
    ]
  end
end
