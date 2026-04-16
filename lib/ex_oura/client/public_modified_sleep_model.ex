defmodule ExOura.Client.PublicModifiedSleepModel do
  @moduledoc """
  Provides struct and type for a PublicModifiedSleepModel
  """

  alias ExOura.Client.Metadata
  alias ExOura.Client.PublicReadiness
  alias ExOura.Client.PublicSample

  @type t :: %__MODULE__{
          app_sleep_phase_5_min: String.t() | nil,
          average_breath: number | nil,
          average_heart_rate: number | nil,
          average_hrv: integer | nil,
          awake_time: integer | nil,
          bedtime_end: String.t(),
          bedtime_start: String.t(),
          day: String.t(),
          deep_sleep_duration: integer | nil,
          efficiency: integer | nil,
          heart_rate: PublicSample.t() | nil,
          hrv: PublicSample.t() | nil,
          id: String.t(),
          latency: integer | nil,
          light_sleep_duration: integer | nil,
          low_battery_alert: boolean,
          lowest_heart_rate: integer | nil,
          meta: Metadata.t(),
          movement_30_sec: String.t() | nil,
          period: integer,
          readiness: PublicReadiness.t() | nil,
          readiness_score_delta: integer | nil,
          rem_sleep_duration: integer | nil,
          restless_periods: integer | nil,
          ring_id: String.t() | nil,
          sleep_algorithm_version: String.t() | nil,
          sleep_analysis_reason: String.t() | nil,
          sleep_phase_30_sec: String.t() | nil,
          sleep_phase_5_min: String.t() | nil,
          sleep_score_delta: integer | nil,
          time_in_bed: integer,
          total_sleep_duration: integer | nil,
          type: String.t() | nil
        }

  defstruct [
    :app_sleep_phase_5_min,
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
    :meta,
    :movement_30_sec,
    :period,
    :readiness,
    :readiness_score_delta,
    :rem_sleep_duration,
    :restless_periods,
    :ring_id,
    :sleep_algorithm_version,
    :sleep_analysis_reason,
    :sleep_phase_30_sec,
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
      app_sleep_phase_5_min: {:union, [:string, :null]},
      average_breath: {:union, [:number, :null]},
      average_heart_rate: {:union, [:number, :null]},
      average_hrv: {:union, [:integer, :null]},
      awake_time: {:union, [:integer, :null]},
      bedtime_end: :string,
      bedtime_start: :string,
      day: :string,
      deep_sleep_duration: {:union, [:integer, :null]},
      efficiency: {:union, [:integer, :null]},
      heart_rate: {:union, [{PublicSample, :t}, :null]},
      hrv: {:union, [{PublicSample, :t}, :null]},
      id: :string,
      latency: {:union, [:integer, :null]},
      light_sleep_duration: {:union, [:integer, :null]},
      low_battery_alert: :boolean,
      lowest_heart_rate: {:union, [:integer, :null]},
      meta: {Metadata, :t},
      movement_30_sec: {:union, [:string, :null]},
      period: :integer,
      readiness: {:union, [{PublicReadiness, :t}, :null]},
      readiness_score_delta: {:union, [:integer, :null]},
      rem_sleep_duration: {:union, [:integer, :null]},
      restless_periods: {:union, [:integer, :null]},
      ring_id: {:union, [:string, :null]},
      sleep_algorithm_version: {:union, [{:enum, ["v1", "v2"]}, :null]},
      sleep_analysis_reason: {:union, [{:enum, ["foreground_sleep_analysis", "bedtime_edit"]}, :null]},
      sleep_phase_30_sec: {:union, [:string, :null]},
      sleep_phase_5_min: {:union, [:string, :null]},
      sleep_score_delta: {:union, [:integer, :null]},
      time_in_bed: :integer,
      total_sleep_duration: {:union, [:integer, :null]},
      type: {:union, [{:enum, ["deleted", "sleep", "long_sleep", "late_nap", "rest"]}, :null]}
    ]
  end
end
