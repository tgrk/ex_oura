defmodule ExOura.Client.TimeSeriesResponseHeartRateModel do
  @moduledoc false
  alias ExOura.Client.HeartRateModel

  @type t :: %__MODULE__{data: [HeartRateModel.t()], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      data: [{HeartRateModel, :t}],
      next_token: {:union, [{:string, :generic}, :null]}
    ]
  end
end
