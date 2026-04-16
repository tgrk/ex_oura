defmodule ExOura.Client.MultiDocumentResponsePublicRingConfiguration do
  @moduledoc """
  Provides struct and type for a MultiDocumentResponsePublicRingConfiguration
  """

  alias ExOura.Client.PublicRingConfiguration

  @type t :: %__MODULE__{
          data: [PublicRingConfiguration.t()],
          next_token: String.t() | nil
        }

  defstruct [:data, :next_token]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [data: [{PublicRingConfiguration, :t}], next_token: {:union, [:string, :null]}]
  end
end
