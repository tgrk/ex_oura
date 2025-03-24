defmodule ExOura.TypeDecoder do
  @moduledoc """
  Decode a response body based on types from the operation
  """

  @spec decode_response(status :: pos_integer(), body :: term(), operation :: map()) ::
          {:ok, term()} | {:error, :unable_to_decode}
  def decode_response(200 = _status, [], _operation), do: {:ok, []}

  def decode_response(status, body, operation) do
    case get_type(operation, status) do
      {:ok, response_type} ->
        {:ok, decode(body, response_type)}

      {:error, :unable_to_decode} = error ->
        error
    end
  end

  defp get_type(%{response: response} = _operation, status) do
    case response |> Map.new() |> Map.get(status, nil) do
      [{_response_type, :t}] = type ->
        {:ok, type}

      {_response_type, :t} = type ->
        {:ok, type}

      _unexpected ->
        {:error, :unable_to_decode}
    end
  end

  defp decode(nil, _response_type), do: nil
  defp decode(value, {:string, :date}), do: Date.from_iso8601!(value)
  defp decode(value, {:union, types}), do: decode(value, union(value, types))

  defp decode(value, [type]), do: Enum.map(value, &decode(&1, type))

  defp decode(%{} = value, {module, type}) do
    base = prepare_base(module)
    fields = module.__fields__(type)

    for {field_name, field_type} <- fields, reduce: base do
      decoded_value ->
        case Map.get(value, field_name) do
          nil ->
            decoded_value

          field_value ->
            Map.put(decoded_value, field_name, decode(field_value, field_type))
        end
    end
  end

  defp decode(value, {type, :t}) do
    with true <- type |> to_string() |> String.ends_with?("Timestamp"),
         {:ok, dt, _} <- DateTime.from_iso8601(value) do
      dt
    else
      _error ->
        value
    end
  end

  defp decode(value, _type), do: value

  defp prepare_base(module) do
    Code.ensure_loaded(module)

    if function_exported?(module, :__struct__, 0) do
      struct(module)
    else
      %{}
    end
  end

  defp union(_value, [type, :null]), do: type
  defp union(value, [:number, {:string, :generic}]) when is_number(value), do: :number
  defp union(_value, [:number, {:string, :generic}]), do: :string
  defp union(value, [:integer, {:string, :generic}]) when is_number(value), do: :integer
  defp union(_value, [:integer, {:string, :generic}]), do: :string

  defp union(_value, types) do
    raise "TypedDecoder: Unable to decode union type #{inspect(types)}"
  end
end
