defmodule ExOura.Client.ResilienceContributors do
  @moduledoc """
  Provides struct and type for a ResilienceContributors
  """

  @type t :: %__MODULE__{daytime_recovery: number, sleep_recovery: number, stress: number}

  defstruct [:daytime_recovery, :sleep_recovery, :stress]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [daytime_recovery: :number, sleep_recovery: :number, stress: :number]
  end
end
