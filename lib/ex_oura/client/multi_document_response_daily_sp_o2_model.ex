defmodule ExOura.Client.MultiDocumentResponseDailySpO2Model do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponseDailySpO2Model
  """

  alias ExOura.Client.DailySpO2Model

  @type t :: %__MODULE__{data: [DailySpO2Model.t()], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      data: [{DailySpO2Model, :t}],
      next_token: {:union, [{:string, :generic}, :null]}
    ]
  end
end
