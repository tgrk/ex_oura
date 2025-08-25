defmodule ExOura.Client.MultiDocumentResponseWorkoutModel do
  @moduledoc false
  alias ExOura.Client.WorkoutModel

  @type t :: %__MODULE__{data: [WorkoutModel.t()], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{WorkoutModel, :t}], next_token: {:union, [{:string, :generic}, :null]}]
  end
end
