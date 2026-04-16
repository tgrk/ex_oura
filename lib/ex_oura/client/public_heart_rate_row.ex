defmodule ExOura.Client.PublicHeartRateRow do
  @moduledoc """
  Provides struct and type for a PublicHeartRateRow
  """

  @type t :: %__MODULE__{
          bpm: integer,
          source: String.t(),
          timestamp: String.t(),
          timestamp_unix: integer
        }

  defstruct [:bpm, :source, :timestamp, :timestamp_unix]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      bpm: :integer,
      source: {:enum, ["awake", "workout", "rest", "sleep", "live", "session"]},
      timestamp: :string,
      timestamp_unix: :integer
    ]
  end
end
