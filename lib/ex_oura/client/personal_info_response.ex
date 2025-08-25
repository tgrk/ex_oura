defmodule ExOura.Client.PersonalInfoResponse do
  @moduledoc false
  @type t :: %__MODULE__{
          age: integer | nil,
          biological_sex: String.t() | nil,
          email: String.t() | nil,
          height: number | nil,
          id: String.t(),
          weight: number | nil
        }

  defstruct [:age, :biological_sex, :email, :height, :id, :weight]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      age: {:union, [:integer, :null]},
      biological_sex: {:union, [{:string, :generic}, :null]},
      email: {:union, [{:string, :generic}, :null]},
      height: {:union, [:number, :null]},
      id: {:string, :generic},
      weight: {:union, [:number, :null]}
    ]
  end
end
