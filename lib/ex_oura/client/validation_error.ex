defmodule ExOura.Client.ValidationError do
  @moduledoc """
  Provides struct and type for a ValidationError
  """

  @type t :: %__MODULE__{
          ctx: map | nil,
          input: any,
          loc: [integer | String.t()],
          msg: String.t(),
          type: String.t()
        }

  defstruct [:ctx, :input, :loc, :msg, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [ctx: :map, input: :any, loc: [union: [:integer, :string]], msg: :string, type: :string]
  end
end
