defmodule ExOura.Client.RestModeEpisode do
  @moduledoc false
  @type t :: %__MODULE__{tags: [String.t()], timestamp: String.t()}

  defstruct [:tags, :timestamp]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [tags: [string: :generic], timestamp: {:string, :generic}]
  end
end
