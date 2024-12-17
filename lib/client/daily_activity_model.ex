defmodule ExOura.Client.DailyActivityModel do
  @moduledoc """
  Provides struct and type for a DailyActivityModel
  """

  @type t :: %__MODULE__{
          active_calories: integer,
          average_met_minutes: number,
          class_5_min: String.t() | nil,
          contributors: ExOura.Client.ActivityContributors.t(),
          day: Date.t(),
          equivalent_walking_distance: integer,
          high_activity_met_minutes: integer,
          high_activity_time: integer,
          id: String.t(),
          inactivity_alerts: integer,
          low_activity_met_minutes: integer,
          low_activity_time: integer,
          medium_activity_met_minutes: integer,
          medium_activity_time: integer,
          met: ExOura.Client.SampleModel.t(),
          meters_to_target: integer,
          non_wear_time: integer,
          resting_time: integer,
          score: integer | nil,
          sedentary_met_minutes: integer,
          sedentary_time: integer,
          steps: integer,
          target_calories: integer,
          target_meters: integer,
          timestamp: ExOura.Client.DailyActivityModelTimestamp.t(),
          total_calories: integer
        }

  defstruct [
    :active_calories,
    :average_met_minutes,
    :class_5_min,
    :contributors,
    :day,
    :equivalent_walking_distance,
    :high_activity_met_minutes,
    :high_activity_time,
    :id,
    :inactivity_alerts,
    :low_activity_met_minutes,
    :low_activity_time,
    :medium_activity_met_minutes,
    :medium_activity_time,
    :met,
    :meters_to_target,
    :non_wear_time,
    :resting_time,
    :score,
    :sedentary_met_minutes,
    :sedentary_time,
    :steps,
    :target_calories,
    :target_meters,
    :timestamp,
    :total_calories
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      active_calories: :integer,
      average_met_minutes: :number,
      class_5_min: {:union, [{:string, :generic}, :null]},
      contributors: {ExOura.Client.ActivityContributors, :t},
      day: {:string, :date},
      equivalent_walking_distance: :integer,
      high_activity_met_minutes: :integer,
      high_activity_time: :integer,
      id: {:string, :generic},
      inactivity_alerts: :integer,
      low_activity_met_minutes: :integer,
      low_activity_time: :integer,
      medium_activity_met_minutes: :integer,
      medium_activity_time: :integer,
      met: {ExOura.Client.SampleModel, :t},
      meters_to_target: :integer,
      non_wear_time: :integer,
      resting_time: :integer,
      score: {:union, [:integer, :null]},
      sedentary_met_minutes: :integer,
      sedentary_time: :integer,
      steps: :integer,
      target_calories: :integer,
      target_meters: :integer,
      timestamp: {ExOura.Client.DailyActivityModelTimestamp, :t},
      total_calories: :integer
    ]
  end
end
