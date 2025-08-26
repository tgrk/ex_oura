defmodule ExOura.Client.MultiDocumentResponseDailyReadinessModel do
  @moduledoc false
  alias ExOura.Client.DailyReadinessModel

  @type t :: %__MODULE__{
          data: [DailyReadinessModel.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      data: [{DailyReadinessModel, :t}],
      next_token: {:union, [{:string, :generic}, :null]}
    ]
  end
end
