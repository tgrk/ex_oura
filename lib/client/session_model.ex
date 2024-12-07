defmodule ExOura.Client.SessionModel do
  @moduledoc """
  Provides struct and type for a SessionModel
  """

  @type t :: %__MODULE__{
          day: Date.t(),
          end_datetime: ExOura.Client.SessionModelEndDatetime.t(),
          heart_rate: ExOura.Client.SampleModel.t() | nil,
          heart_rate_variability: ExOura.Client.SampleModel.t() | nil,
          id: String.t(),
          mood: String.t() | nil,
          motion_count: ExOura.Client.SampleModel.t() | nil,
          start_datetime: ExOura.Client.SessionModelStartDatetime.t(),
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
      end_datetime: {ExOura.Client.SessionModelEndDatetime, :t},
      heart_rate: {:union, [{ExOura.Client.SampleModel, :t}, :null]},
      heart_rate_variability: {:union, [{ExOura.Client.SampleModel, :t}, :null]},
      id: {:string, :generic},
      mood: {:union, [{:enum, ["bad", "worse", "same", "good", "great"]}, :null]},
      motion_count: {:union, [{ExOura.Client.SampleModel, :t}, :null]},
      start_datetime: {ExOura.Client.SessionModelStartDatetime, :t},
      type: {:enum, ["breathing", "meditation", "nap", "relaxation", "rest", "body_status"]}
    ]
  end
end
