defmodule ExOura.Client.DailySleepModelContributors do
  @moduledoc false
  @type t :: %__MODULE__{
          deep_sleep: integer | nil,
          efficiency: integer | nil,
          latency: integer | nil,
          rem_sleep: integer | nil,
          restfulness: integer | nil,
          timing: integer | nil,
          total_sleep: integer | nil
        }

  defstruct [:deep_sleep, :efficiency, :latency, :rem_sleep, :restfulness, :timing, :total_sleep]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      deep_sleep: {:union, [:integer, :null]},
      efficiency: {:union, [:integer, :null]},
      latency: {:union, [:integer, :null]},
      rem_sleep: {:union, [:integer, :null]},
      restfulness: {:union, [:integer, :null]},
      timing: {:union, [:integer, :null]},
      total_sleep: {:union, [:integer, :null]}
    ]
  end
end
