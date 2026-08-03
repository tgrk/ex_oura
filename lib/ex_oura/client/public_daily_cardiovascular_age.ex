defmodule ExOura.Client.PublicDailyCardiovascularAge do
  @moduledoc """
  Provides struct and type for a PublicDailyCardiovascularAge
  """

  @type t :: %__MODULE__{
          day: String.t(),
          id: String.t(),
          pulse_wave_velocity: number | nil,
          vascular_age: integer | nil
        }

  defstruct [:day, :id, :pulse_wave_velocity, :vascular_age]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      day: :string,
      id: :string,
      pulse_wave_velocity: {:union, [:number, :null]},
      vascular_age: {:union, [:integer, :null]}
    ]
  end
end
