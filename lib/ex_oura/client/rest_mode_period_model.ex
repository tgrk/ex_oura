defmodule ExOura.Client.RestModePeriodModel do
  @moduledoc """
  Provides struct and type for a RestModePeriodModel
  """

  alias ExOura.Client.RestModeEpisode

  @type t :: %__MODULE__{
          end_day: Date.t() | nil,
          end_time: String.t() | nil,
          episodes: [RestModeEpisode.t()],
          id: String.t(),
          start_day: Date.t(),
          start_time: String.t() | nil
        }

  defstruct [:end_day, :end_time, :episodes, :id, :start_day, :start_time]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      end_day: {:union, [{:string, :date}, :null]},
      end_time: {:union, [{:string, :generic}, :null]},
      episodes: [{RestModeEpisode, :t}],
      id: {:string, :generic},
      start_day: {:string, :date},
      start_time: {:union, [{:string, :generic}, :null]}
    ]
  end
end
