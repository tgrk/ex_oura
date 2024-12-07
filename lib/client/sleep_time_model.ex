defmodule ExOura.Client.SleepTimeModel do
  @moduledoc """
  Provides struct and type for a SleepTimeModel
  """

  @type t :: %__MODULE__{
          day: Date.t(),
          id: String.t(),
          optimal_bedtime: ExOura.Client.SleepTimeWindow.t() | nil,
          recommendation: String.t() | nil,
          status: String.t() | nil
        }

  defstruct [:day, :id, :optimal_bedtime, :recommendation, :status]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      day: {:string, :date},
      id: {:string, :generic},
      optimal_bedtime: {:union, [{ExOura.Client.SleepTimeWindow, :t}, :null]},
      recommendation:
        {:union,
         [
           {:enum,
            [
              "improve_efficiency",
              "earlier_bedtime",
              "later_bedtime",
              "earlier_wake_up_time",
              "later_wake_up_time",
              "follow_optimal_bedtime"
            ]},
           :null
         ]},
      status:
        {:union,
         [
           {:enum,
            [
              "not_enough_nights",
              "not_enough_recent_nights",
              "bad_sleep_quality",
              "only_recommended_found",
              "optimal_found"
            ]},
           :null
         ]}
    ]
  end
end
