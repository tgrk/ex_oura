defmodule ExOura.PaginationTest do
  use ExUnit.Case, async: true

  alias ExOura.Pagination

  describe "fetch_all_pages/4" do
    test "returns all data when single page response has no next_token" do
      fetch_fn = fn _start_date, _end_date, nil, _opts ->
        {:ok, %{data: [%{id: "1"}, %{id: "2"}], next_token: nil}}
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      assert {:ok, data} = Pagination.fetch_all_pages(fetch_fn, start_date, end_date)
      assert length(data) == 2
      assert data == [%{id: "1"}, %{id: "2"}]
    end

    test "fetches multiple pages when next_token is present" do
      # Mock function that returns different pages based on next_token
      fetch_fn = fn _start_date, _end_date, next_token, _opts ->
        case next_token do
          nil ->
            {:ok, %{data: [%{id: "1"}], next_token: "token_page_2"}}

          "token_page_2" ->
            {:ok, %{data: [%{id: "2"}], next_token: "token_page_3"}}

          "token_page_3" ->
            {:ok, %{data: [%{id: "3"}], next_token: nil}}
        end
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      assert {:ok, data} = Pagination.fetch_all_pages(fetch_fn, start_date, end_date)
      assert length(data) == 3
      assert data == [%{id: "1"}, %{id: "2"}, %{id: "3"}]
    end

    test "handles empty data responses" do
      fetch_fn = fn _start_date, _end_date, nil, _opts ->
        {:ok, %{data: [], next_token: nil}}
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      assert {:ok, data} = Pagination.fetch_all_pages(fetch_fn, start_date, end_date)
      assert data == []
    end

    test "returns error when fetch function fails" do
      fetch_fn = fn _start_date, _end_date, _next_token, _opts ->
        {:error, :network_error}
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      assert {:error, :network_error} = Pagination.fetch_all_pages(fetch_fn, start_date, end_date)
    end

    test "returns error when fetch function fails on subsequent page" do
      fetch_fn = fn _start_date, _end_date, next_token, _opts ->
        case next_token do
          nil ->
            {:ok, %{data: [%{id: "1"}], next_token: "token_page_2"}}

          "token_page_2" ->
            {:error, :rate_limited}
        end
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      assert {:error, :rate_limited} = Pagination.fetch_all_pages(fetch_fn, start_date, end_date)
    end

    test "respects max_pages option" do
      fetch_fn = fn _start_date, _end_date, next_token, _opts ->
        case next_token do
          nil ->
            {:ok, %{data: [%{id: "1"}], next_token: "token_page_2"}}

          "token_page_2" ->
            {:ok, %{data: [%{id: "2"}], next_token: "token_page_3"}}

          "token_page_3" ->
            {:ok, %{data: [%{id: "3"}], next_token: "token_page_4"}}

          "token_page_4" ->
            {:ok, %{data: [%{id: "4"}], next_token: nil}}
        end
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      assert {:error, {:max_pages_exceeded, 2}} =
               Pagination.fetch_all_pages(fetch_fn, start_date, end_date, max_pages: 2)
    end

    test "handles response with string keys" do
      fetch_fn = fn _start_date, _end_date, nil, _opts ->
        {:ok, %{"data" => [%{"id" => "1"}], "next_token" => nil}}
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      assert {:ok, data} = Pagination.fetch_all_pages(fetch_fn, start_date, end_date)
      assert data == [%{"id" => "1"}]
    end

    test "handles malformed response gracefully" do
      fetch_fn = fn _start_date, _end_date, nil, _opts ->
        {:ok, %{unexpected: "structure"}}
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      assert {:ok, data} = Pagination.fetch_all_pages(fetch_fn, start_date, end_date)
      assert data == []
    end

    test "passes through options to fetch function" do
      test_pid = self()

      fetch_fn = fn _start_date, _end_date, _next_token, opts ->
        send(test_pid, {:received_opts, opts})
        {:ok, %{data: [], next_token: nil}}
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]
      custom_opts = [custom_option: :value]

      Pagination.fetch_all_pages(fetch_fn, start_date, end_date, custom_opts)

      assert_received {:received_opts, received_opts}
      assert Keyword.get(received_opts, :custom_option) == :value
    end
  end

  describe "stream_all_pages/4" do
    test "streams all data from multiple pages" do
      fetch_fn = fn _start_date, _end_date, next_token, _opts ->
        case next_token do
          nil ->
            {:ok, %{data: [%{id: "1"}, %{id: "2"}], next_token: "token_page_2"}}

          "token_page_2" ->
            {:ok, %{data: [%{id: "3"}], next_token: nil}}
        end
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      stream = Pagination.stream_all_pages(fetch_fn, start_date, end_date)
      data = Enum.to_list(stream)

      assert length(data) == 3
      assert data == [%{id: "1"}, %{id: "2"}, %{id: "3"}]
    end

    test "handles empty stream" do
      fetch_fn = fn _start_date, _end_date, nil, _opts ->
        {:ok, %{data: [], next_token: nil}}
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      stream = Pagination.stream_all_pages(fetch_fn, start_date, end_date)
      data = Enum.to_list(stream)

      assert data == []
    end

    test "raises when fetch function returns error" do
      fetch_fn = fn _start_date, _end_date, _next_token, _opts ->
        {:error, :network_error}
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      stream = Pagination.stream_all_pages(fetch_fn, start_date, end_date)

      assert_raise RuntimeError, "Failed to fetch page: :network_error", fn ->
        Enum.to_list(stream)
      end
    end
  end

  describe "extract_data_from_response/1 (via public interface)" do
    test "integration test with various response formats" do
      # Test with atom keys
      fetch_fn_atoms = fn _start_date, _end_date, nil, _opts ->
        {:ok, %{data: [%{id: "1"}], next_token: nil}}
      end

      # Test with string keys
      fetch_fn_strings = fn _start_date, _end_date, nil, _opts ->
        {:ok, %{"data" => [%{"id" => "2"}], "next_token" => nil}}
      end

      # Test with nil data
      fetch_fn_nil_data = fn _start_date, _end_date, nil, _opts ->
        {:ok, %{data: nil, next_token: nil}}
      end

      start_date = ~D[2025-01-01]
      end_date = ~D[2025-01-31]

      {:ok, result1} = Pagination.fetch_all_pages(fetch_fn_atoms, start_date, end_date)
      assert result1 == [%{id: "1"}]

      {:ok, result2} = Pagination.fetch_all_pages(fetch_fn_strings, start_date, end_date)
      assert result2 == [%{"id" => "2"}]

      {:ok, result3} = Pagination.fetch_all_pages(fetch_fn_nil_data, start_date, end_date)
      assert result3 == []
    end
  end
end
