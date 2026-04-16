defmodule ExOura.Client.PublicRestModeEpisode do
  @moduledoc """
  Provides struct and type for a PublicRestModeEpisode
  """

  @type t :: %__MODULE__{tags: [String.t()], timestamp: String.t()}

  defstruct [:tags, :timestamp]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [tags: [:string], timestamp: :string]
  end
end
