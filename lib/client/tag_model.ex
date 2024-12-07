defmodule ExOura.Client.TagModel do
  @moduledoc """
  Provides struct and type for a TagModel
  """

  @type t :: %__MODULE__{
          day: Date.t(),
          id: String.t(),
          tags: [String.t()],
          text: String.t() | nil,
          timestamp: DateTime.t()
        }

  defstruct [:day, :id, :tags, :text, :timestamp]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      day: {:string, :date},
      id: {:string, :generic},
      tags: [string: :generic],
      text: {:union, [{:string, :generic}, :null]},
      timestamp: {:string, :date_time}
    ]
  end
end
