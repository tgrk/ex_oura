defmodule ExOura.Client.Vo2MaxModel do
  @moduledoc """
  Provides struct and type for a Vo2MaxModel
  """

  @type t :: %__MODULE__{
          day: Date.t(),
          id: String.t(),
          timestamp: ExOura.Client.Vo2MaxModelTimestamp.t(),
          vo2_max: number | nil
        }

  defstruct [:day, :id, :timestamp, :vo2_max]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      day: {:string, :date},
      id: {:string, :generic},
      timestamp: {ExOura.Client.Vo2MaxModelTimestamp, :t},
      vo2_max: {:union, [:number, :null]}
    ]
  end
end
