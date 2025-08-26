defmodule ExOura.Client.HeartRateModel do
  @moduledoc false
  @type t :: %__MODULE__{bpm: integer, source: String.t(), timestamp: String.t()}

  defstruct [:bpm, :source, :timestamp]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      bpm: :integer,
      source: {:enum, ["awake", "rest", "sleep", "session", "live", "workout"]},
      timestamp: {:string, :generic}
    ]
  end
end
