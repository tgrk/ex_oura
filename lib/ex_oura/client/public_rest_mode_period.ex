defmodule ExOura.Client.PublicRestModePeriod do
  @moduledoc """
  Provides struct and type for a PublicRestModePeriod
  """

  alias ExOura.Client.Metadata
  alias ExOura.Client.PublicRestModeEpisode

  @type t :: %__MODULE__{
          end_day: String.t() | nil,
          end_time: String.t() | nil,
          episodes: [PublicRestModeEpisode.t()],
          id: String.t(),
          meta: Metadata.t(),
          start_day: String.t(),
          start_time: String.t() | nil
        }

  defstruct [:end_day, :end_time, :episodes, :id, :meta, :start_day, :start_time]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      end_day: {:union, [:string, :null]},
      end_time: {:union, [:string, :null]},
      episodes: [{PublicRestModeEpisode, :t}],
      id: :string,
      meta: {Metadata, :t},
      start_day: :string,
      start_time: {:union, [:string, :null]}
    ]
  end
end
