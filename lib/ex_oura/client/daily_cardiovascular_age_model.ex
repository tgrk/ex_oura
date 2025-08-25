defmodule ExOura.Client.DailyCardiovascularAgeModel do
  @moduledoc """
  Provides struct and type for a DailyCardiovascularAgeModel
  """

  @type t :: %__MODULE__{day: Date.t(), vascular_age: integer | nil}

  defstruct [:day, :vascular_age]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [day: {:string, :date}, vascular_age: {:union, [:integer, :null]}]
  end
end
