defmodule ExOura.Client.PublicSession do
  @moduledoc """
  Provides struct and type for a PublicSession
  """

  alias ExOura.Client.PublicSample

  @type t :: %__MODULE__{
          day: String.t(),
          end_datetime: String.t(),
          heart_rate: PublicSample.t() | nil,
          heart_rate_variability: PublicSample.t() | nil,
          id: String.t(),
          mood: String.t() | nil,
          motion_count: PublicSample.t() | nil,
          start_datetime: String.t(),
          type: String.t()
        }

  defstruct [
    :day,
    :end_datetime,
    :heart_rate,
    :heart_rate_variability,
    :id,
    :mood,
    :motion_count,
    :start_datetime,
    :type
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      day: :string,
      end_datetime: :string,
      heart_rate: {:union, [{PublicSample, :t}, :null]},
      heart_rate_variability: {:union, [{PublicSample, :t}, :null]},
      id: :string,
      mood: {:union, [{:enum, ["bad", "worse", "same", "good", "great"]}, :null]},
      motion_count: {:union, [{PublicSample, :t}, :null]},
      start_datetime: :string,
      type: {:enum, ["breathing", "meditation", "nap", "relaxation", "rest", "body_status"]}
    ]
  end
end
