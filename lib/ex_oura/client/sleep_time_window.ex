defmodule ExOura.Client.SleepTimeWindow do
  @moduledoc false
  @type t :: %__MODULE__{day_tz: integer, end_offset: integer, start_offset: integer}

  defstruct [:day_tz, :end_offset, :start_offset]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [day_tz: :integer, end_offset: :integer, start_offset: :integer]
  end
end
