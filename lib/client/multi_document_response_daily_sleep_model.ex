defmodule ExOura.Client.MultiDocumentResponseDailySleepModel do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponseDailySleepModel
  """

  @type t :: %__MODULE__{data: [ExOura.Client.DailySleepModel.t()], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      data: [{ExOura.Client.DailySleepModel, :t}],
      next_token: {:union, [{:string, :generic}, :null]}
    ]
  end
end
