defmodule ExOura.Client.MultiDocumentResponseVo2MaxModel do
  @moduledoc false
  alias ExOura.Client.Vo2MaxModel

  @type t :: %__MODULE__{data: [Vo2MaxModel.t()], next_token: String.t() | nil}

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{Vo2MaxModel, :t}], next_token: {:union, [{:string, :generic}, :null]}]
  end
end
