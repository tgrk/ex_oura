defmodule ExOura.Client.PublicDailySleep do
  @moduledoc """
  Provides struct and type for a PublicDailySleep
  """

  alias ExOura.Client.Metadata
  alias ExOura.Client.PublicSleepContributors

  @type t :: %__MODULE__{
          contributors: PublicSleepContributors.t(),
          day: String.t(),
          id: String.t(),
          meta: Metadata.t(),
          score: integer | nil,
          timestamp: String.t()
        }

  defstruct [:contributors, :day, :id, :meta, :score, :timestamp]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      contributors: {PublicSleepContributors, :t},
      day: :string,
      id: :string,
      meta: {Metadata, :t},
      score: {:union, [:integer, :null]},
      timestamp: :string
    ]
  end
end
