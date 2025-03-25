defmodule ExOura.Client.RestModeEpisode do
  @moduledoc """
  Provides struct and type for a RestModeEpisode
  """

  alias ExOura.Client.Timestamp

  @type t :: %__MODULE__{tags: [String.t()], timestamp: Timestamp.t()}

  defstruct [:tags, :timestamp]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [tags: [string: :generic], timestamp: {Timestamp, :t}]
  end
end
