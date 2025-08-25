defmodule ExOura.Client.MultiDocumentResponseDailyCardiovascularAgeModel do
  @moduledoc false
  alias ExOura.Client.DailyCardiovascularAgeModel

  @type t :: %__MODULE__{
          data: [DailyCardiovascularAgeModel.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      data: [{DailyCardiovascularAgeModel, :t}],
      next_token: {:union, [{:string, :generic}, :null]}
    ]
  end
end
