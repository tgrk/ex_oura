defmodule ExOura.Client.HTTPValidationError do
  @moduledoc """
  Provides struct and type for a HTTPValidationError
  """

  @type t :: %__MODULE__{detail: [ExOura.Client.ValidationError.t()] | nil}

  defstruct [:detail]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [detail: [{ExOura.Client.ValidationError, :t}]]
  end
end
