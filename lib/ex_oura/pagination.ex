defmodule ExOura.Pagination do
  @moduledoc """
  Helper functions for handling paginated responses from Oura API.

  This module provides utilities to automatically fetch all pages of data
  from paginated endpoints, handling the `next_token` mechanism used by
  the Oura API.
  """

  @doc """
  Fetches all pages of data from a paginated endpoint.

  ## Parameters

    * `fetch_fn` - A function that takes (start_date, end_date, next_token, opts)
      and returns {:ok, response} or {:error, reason}
    * `start_date` - The start date for the data range
    * `end_date` - The end date for the data range
    * `opts` - Additional options to pass to the fetch function

  ## Examples

      iex> fetch_fn = fn start_date, end_date, next_token, opts ->
      ...>   ExOura.multiple_daily_activity(start_date, end_date, next_token, opts)
      ...> end
      iex> ExOura.Pagination.fetch_all_pages(fetch_fn, ~D[2025-01-01], ~D[2025-01-31])
      {:ok, [%{id: "1", ...}, %{id: "2", ...}]}

  ## Returns

    * `{:ok, data}` - All data from all pages combined into a single list
    * `{:error, reason}` - If any page fetch fails
  """
  @spec fetch_all_pages(
          fetch_function :: (Date.t(), Date.t(), String.t() | nil, keyword() ->
                               {:ok, map()} | {:error, any()}),
          start_date :: Date.t(),
          end_date :: Date.t(),
          opts :: keyword()
        ) :: {:ok, list()} | {:error, any()}
  def fetch_all_pages(fetch_fn, start_date, end_date, opts \\ []) when is_function(fetch_fn, 4) do
    max_pages = Keyword.get(opts, :max_pages, 100)
    fetch_all_pages_recursive(fetch_fn, start_date, end_date, nil, [], opts, 1, max_pages)
  end

  @doc """
  Fetches all pages using a stream for memory efficiency.

  This function returns a stream that yields individual data items across
  all pages, allowing for memory-efficient processing of large datasets.

  ## Parameters

    * `fetch_fn` - A function that takes (start_date, end_date, next_token, opts)
    * `start_date` - The start date for the data range
    * `end_date` - The end date for the data range
    * `opts` - Additional options

  ## Returns

    * `Enumerable.t()` - A stream of individual data items
  """
  @spec stream_all_pages(
          fetch_function :: (Date.t(), Date.t(), String.t() | nil, keyword() ->
                               {:ok, map()} | {:error, any()}),
          start_date :: Date.t(),
          end_date :: Date.t(),
          opts :: keyword()
        ) :: Enumerable.t()
  def stream_all_pages(fetch_fn, start_date, end_date, opts \\ []) when is_function(fetch_fn, 4) do
    Stream.resource(
      fn -> {nil, true} end,
      fn
        {_token, false} ->
          {:halt, nil}

        {next_token, true} ->
          case fetch_fn.(start_date, end_date, next_token, opts) do
            {:ok, response} ->
              data = extract_data_from_response(response)
              new_next_token = extract_next_token_from_response(response)
              has_more = new_next_token != nil

              {data, {new_next_token, has_more}}

            {:error, reason} ->
              raise "Failed to fetch page: #{inspect(reason)}"
          end
      end,
      fn _ -> :ok end
    )
  end

  # Private functions

  defp fetch_all_pages_recursive(_fetch_fn, _start_date, _end_date, _next_token, _acc, _opts, page, max_pages)
       when page > max_pages do
    {:error, {:max_pages_exceeded, max_pages}}
  end

  defp fetch_all_pages_recursive(fetch_fn, start_date, end_date, next_token, acc, opts, page, max_pages) do
    case fetch_fn.(start_date, end_date, next_token, opts) do
      {:ok, response} ->
        data = extract_data_from_response(response)
        new_next_token = extract_next_token_from_response(response)

        new_acc = acc ++ data

        case new_next_token do
          nil ->
            {:ok, new_acc}

          token when is_binary(token) ->
            fetch_all_pages_recursive(
              fetch_fn,
              start_date,
              end_date,
              token,
              new_acc,
              opts,
              page + 1,
              max_pages
            )
        end

      {:error, _} = error ->
        error
    end
  end

  defp extract_data_from_response(%{data: data}) when is_list(data), do: data

  defp extract_data_from_response(response) when is_map(response) do
    # Handle different response structures
    cond do
      Map.has_key?(response, :data) -> response.data || []
      Map.has_key?(response, "data") -> response["data"] || []
      true -> []
    end
  end

  defp extract_data_from_response(_), do: []

  defp extract_next_token_from_response(%{next_token: next_token}), do: next_token
  defp extract_next_token_from_response(%{"next_token" => next_token}), do: next_token
  defp extract_next_token_from_response(_), do: nil
end
