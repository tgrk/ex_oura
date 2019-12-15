defmodule OuraCloudAPI.PersonalInfo do
  @moduledoc """
  A struct representing a personal information.
  """

  use TypedStruct

  @typedoc "A personal information"
  typedstruct do
    field(:age, non_neg_integer())
    field(:weigth, non_neg_integer())
    field(:gender, atom(), default: :male)
    field(:email, String.t())
  end
end
