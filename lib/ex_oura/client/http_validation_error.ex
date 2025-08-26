defmodule ExOura.Client.HTTPValidationError do
  @moduledoc false
  alias ExOura.Client.ValidationError

  @type t :: %__MODULE__{detail: [ValidationError.t()] | nil}

  defstruct [:detail]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [detail: [{ValidationError, :t}]]
  end
end
