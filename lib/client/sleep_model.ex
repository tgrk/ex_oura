defmodule ExOura.Client.SleepModel do
  @moduledoc """
  Provides struct and type for a SleepModel
  """

  alias ExOura.Client.ReadinessSummary
  alias ExOura.Client.SampleModel
  alias ExOura.Client.SleepModelBedtimeEnd
  alias ExOura.Client.SleepModelBedtimeStart

  @type t :: %__MODULE__{
          average_breath: number | nil,
          average_heart_rate: number | nil,
          average_hrv: integer | nil,
          awake_time: integer | nil,
          bedtime_end: SleepModelBedtimeEnd.t(),
          bedtime_start: SleepModelBedtimeStart.t(),
          day: Date.t(),
          deep_sleep_duration: integer | nil,
          efficiency: integer | nil,
          heart_rate: SampleModel.t() | nil,
          hrv: SampleModel.t() | nil,
          id: String.t(),
          latency: integer | nil,
          light_sleep_duration: integer | nil,
          low_battery_alert: boolean,
          lowest_heart_rate: integer | nil,
          movement_30_sec: String.t() | nil,
          period: integer,
          readiness: ReadinessSummary.t() | nil,
          readiness_score_delta: integer | nil,
          rem_sleep_duration: integer | nil,
          restless_periods: integer | nil,
          sleep_algorithm_version: String.t() | nil,
          sleep_phase_5_min: String.t() | nil,
          sleep_score_delta: integer | nil,
          time_in_bed: integer,
          total_sleep_duration: integer | nil,
          type: String.t()
        }

  defstruct [
    :average_breath,
    :average_heart_rate,
    :average_hrv,
    :awake_time,
    :bedtime_end,
    :bedtime_start,
    :day,
    :deep_sleep_duration,
    :efficiency,
    :heart_rate,
    :hrv,
    :id,
    :latency,
    :light_sleep_duration,
    :low_battery_alert,
    :lowest_heart_rate,
    :movement_30_sec,
    :period,
    :readiness,
    :readiness_score_delta,
    :rem_sleep_duration,
    :restless_periods,
    :sleep_algorithm_version,
    :sleep_phase_5_min,
    :sleep_score_delta,
    :time_in_bed,
    :total_sleep_duration,
    :type
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      average_breath: {:union, [:number, :null]},
      average_heart_rate: {:union, [:number, :null]},
      average_hrv: {:union, [:integer, :null]},
      awake_time: {:union, [:integer, :null]},
      bedtime_end: {SleepModelBedtimeEnd, :t},
      bedtime_start: {SleepModelBedtimeStart, :t},
      day: {:string, :date},
      deep_sleep_duration: {:union, [:integer, :null]},
      efficiency: {:union, [:integer, :null]},
      heart_rate: {:union, [{SampleModel, :t}, :null]},
      hrv: {:union, [{SampleModel, :t}, :null]},
      id: {:string, :generic},
      latency: {:union, [:integer, :null]},
      light_sleep_duration: {:union, [:integer, :null]},
      low_battery_alert: :boolean,
      lowest_heart_rate: {:union, [:integer, :null]},
      movement_30_sec: {:union, [{:string, :generic}, :null]},
      period: :integer,
      readiness: {:union, [{ReadinessSummary, :t}, :null]},
      readiness_score_delta: {:union, [:integer, :null]},
      rem_sleep_duration: {:union, [:integer, :null]},
      restless_periods: {:union, [:integer, :null]},
      sleep_algorithm_version: {:union, [{:enum, ["v1", "v2"]}, :null]},
      sleep_phase_5_min: {:union, [{:string, :generic}, :null]},
      sleep_score_delta: {:union, [:integer, :null]},
      time_in_bed: :integer,
      total_sleep_duration: {:union, [:integer, :null]},
      type: {:enum, ["deleted", "sleep", "long_sleep", "late_nap", "rest"]}
    ]
  end
end
