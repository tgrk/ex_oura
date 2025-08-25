defmodule ExOura.Client.MultiDocumentResponseSleepTimeModel do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponseSleepTimeModel
  """

  alias ExOura.Client.SleepTimeModel

  @type t :: %__MODULE__{data: [SleepTimeModel.t()], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      data: [{SleepTimeModel, :t}],
      next_token: {:union, [{:string, :generic}, :null]}
    ]
  end
end
