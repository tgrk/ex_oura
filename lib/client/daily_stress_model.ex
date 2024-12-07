defmodule ExOura.Client.DailyStressModel do
  @moduledoc """
  Provides struct and type for a DailyStressModel
  """

  @type t :: %__MODULE__{
          day: Date.t(),
          day_summary: String.t() | nil,
          id: String.t(),
          recovery_high: integer | nil,
          stress_high: integer | nil
        }

  defstruct [:day, :day_summary, :id, :recovery_high, :stress_high]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      day: {:string, :date},
      day_summary: {:union, [{:enum, ["restored", "normal", "stressful"]}, :null]},
      id: {:string, :generic},
      recovery_high: {:union, [:integer, :null]},
      stress_high: {:union, [:integer, :null]}
    ]
  end
end
