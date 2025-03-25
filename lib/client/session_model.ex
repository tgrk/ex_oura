defmodule ExOura.Client.SessionModel do
  @moduledoc """
  Provides struct and type for a SessionModel
  """

  alias ExOura.Client.SampleModel
  alias ExOura.Client.SessionModelEndDatetime
  alias ExOura.Client.SessionModelStartDatetime

  @type t :: %__MODULE__{
          day: Date.t(),
          end_datetime: SessionModelEndDatetime.t(),
          heart_rate: SampleModel.t() | nil,
          heart_rate_variability: SampleModel.t() | nil,
          id: String.t(),
          mood: String.t() | nil,
          motion_count: SampleModel.t() | nil,
          start_datetime: SessionModelStartDatetime.t(),
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
      day: {:string, :date},
      end_datetime: {SessionModelEndDatetime, :t},
      heart_rate: {:union, [{SampleModel, :t}, :null]},
      heart_rate_variability: {:union, [{SampleModel, :t}, :null]},
      id: {:string, :generic},
      mood: {:union, [{:enum, ["bad", "worse", "same", "good", "great"]}, :null]},
      motion_count: {:union, [{SampleModel, :t}, :null]},
      start_datetime: {SessionModelStartDatetime, :t},
      type: {:enum, ["breathing", "meditation", "nap", "relaxation", "rest", "body_status"]}
    ]
  end
end
