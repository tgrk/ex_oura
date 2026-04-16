defmodule ExOura.Client.PublicDailySpO2 do
  @moduledoc """
  Provides struct and type for a PublicDailySpO2
  """

  alias ExOura.Client.Metadata
  alias ExOura.Client.PublicSpo2AggregatedValues

  @type t :: %__MODULE__{
          breathing_disturbance_index: integer | nil,
          day: String.t(),
          id: String.t(),
          meta: Metadata.t(),
          spo2_percentage: PublicSpo2AggregatedValues.t() | nil
        }

  defstruct [:breathing_disturbance_index, :day, :id, :meta, :spo2_percentage]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      breathing_disturbance_index: {:union, [:integer, :null]},
      day: :string,
      id: :string,
      meta: {Metadata, :t},
      spo2_percentage: {:union, [{PublicSpo2AggregatedValues, :t}, :null]}
    ]
  end
end
