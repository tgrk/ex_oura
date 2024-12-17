defmodule ExOura.Client.EnhancedTagModel do
  @moduledoc """
  Provides struct and type for a EnhancedTagModel
  """

  @type t :: %__MODULE__{
          comment: String.t() | nil,
          custom_name: String.t() | nil,
          end_day: Date.t() | nil,
          end_time: String.t() | nil,
          id: String.t(),
          start_day: Date.t(),
          start_time: ExOura.Client.EnhancedTagModelStartTime.t(),
          tag_type_code: String.t() | nil
        }

  defstruct [
    :comment,
    :custom_name,
    :end_day,
    :end_time,
    :id,
    :start_day,
    :start_time,
    :tag_type_code
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      comment: {:union, [{:string, :generic}, :null]},
      custom_name: {:union, [{:string, :generic}, :null]},
      end_day: {:union, [{:string, :date}, :null]},
      end_time: {:union, [{:string, :generic}, :null]},
      id: {:string, :generic},
      start_day: {:string, :date},
      start_time: {ExOura.Client.EnhancedTagModelStartTime, :t},
      tag_type_code: {:union, [{:string, :generic}, :null]}
    ]
  end
end
