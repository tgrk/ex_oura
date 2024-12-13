defmodule ExOura.Client.DailySpO2Model do
  @moduledoc """
  Provides struct and type for a DailySpO2Model
  """

  @type t :: %__MODULE__{
          breathing_disturbance_index: integer | nil,
          day: Date.t(),
          id: String.t(),
          spo2_percentage: ExOura.Client.DailySpO2AggregatedValuesModel.t() | nil
        }

  defstruct [:breathing_disturbance_index, :day, :id, :spo2_percentage]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      breathing_disturbance_index: {:union, [:integer, :null]},
      day: {:string, :date},
      id: {:string, :generic},
      spo2_percentage: {:union, [{ExOura.Client.DailySpO2AggregatedValuesModel, :t}, :null]}
    ]
  end
end
