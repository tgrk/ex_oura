defmodule ExOura.ClientOAuth2Test do
  use ExUnit.Case, async: false

  import Mock

  alias ExOura.Client

  setup do
    # Stop any existing client safely
    case Process.whereis(Client) do
      pid when is_pid(pid) ->
        if Process.alive?(pid) do
          GenServer.stop(Client, :normal, 1000)
        end

      nil ->
        :ok
    end

    :ok
  end

  describe "OAuth2 authentication" do
    test "starts client with OAuth2 access token only" do
      access_token = "oauth2_access_token"

      assert {:ok, _pid} = Client.start_link(access_token)

      {:ok, token_info} = Client.get_token_info()
      assert token_info.access_token == access_token
      assert token_info.refresh_token == nil
      assert token_info.auth_type == :bearer
    end

    test "starts client with OAuth2 tokens including refresh token" do
      auth_config = [
        access_token: "oauth2_access_token",
        refresh_token: "oauth2_refresh_token"
      ]

      assert {:ok, _pid} = Client.start_link(auth_config)

      {:ok, token_info} = Client.get_token_info()
      assert token_info.access_token == "oauth2_access_token"
      assert token_info.refresh_token == "oauth2_refresh_token"
      assert token_info.auth_type == :oauth2
    end

    test "starts client with only access token in keyword list" do
      auth_config = [access_token: "oauth2_access_token"]

      assert {:ok, _pid} = Client.start_link(auth_config)

      {:ok, token_info} = Client.get_token_info()
      assert token_info.access_token == "oauth2_access_token"
      assert token_info.refresh_token == nil
      assert token_info.auth_type == :oauth2
    end
  end

  describe "OAuth2 token refresh" do
    setup do
      # Mock OAuth2 configuration
      original_config = Application.get_env(:ex_oura, :oauth2)

      on_exit(fn ->
        if original_config,
          do: Application.put_env(:ex_oura, :oauth2, original_config),
          else: Application.delete_env(:ex_oura, :oauth2)
      end)

      Application.put_env(:ex_oura, :oauth2,
        client_id: "test_client_id",
        client_secret: "test_client_secret",
        redirect_uri: "http://localhost:3000/callback"
      )

      auth_config = [
        access_token: "old_access_token",
        refresh_token: "oauth2_refresh_token",
        expires_at: NaiveDateTime.add(NaiveDateTime.utc_now(), 86_400),
        expires_in: 86_400
      ]

      {:ok, _pid} = Client.start_link(auth_config)

      :ok
    end

    test "successfully refreshes OAuth2 token" do
      successful_response = %Req.Response{
        status: 200,
        body: %{
          access_token: "new_access_token",
          refresh_token: "new_refresh_token_value",
          token_type: "Bearer",
          expires_at: NaiveDateTime.add(NaiveDateTime.utc_now(), 86_400),
          expires_in: 86_400,
          scope: "daily personal"
        }
      }

      with_mock Req, [:passthrough], post: fn _url, _opts -> {:ok, successful_response} end do
        assert {:ok, new_token_info} = Client.refresh_oauth2_token()

        assert new_token_info.access_token == "new_access_token"
        assert new_token_info.refresh_token == "new_refresh_token_value"
        assert new_token_info.auth_type == :oauth2

        # Verify client state was updated
        assert {:ok, current_token_info} = Client.get_token_info()
        assert current_token_info.access_token == new_token_info.access_token
        assert current_token_info.refresh_token == new_token_info.refresh_token
      end
    end

    test "accepts a NaiveDateTime expiry and refreshes 60s before it" do
      response = %Req.Response{
        status: 200,
        body: %{access_token: "new_access_token", refresh_token: "new_refresh_token", expires_in: 86_400}
      }

      with_mock Req, [:passthrough], post: fn _url, _opts -> {:ok, response} end do
        # Far-future NaiveDateTime from setup: no crash, no refresh
        assert {:ok, "old_access_token"} = GenServer.call(Client, :access_token)
        assert_not_called(Req.post(:_, :_))

        :ok =
          Client.set_auth_config(
            access_token: "old_access_token",
            refresh_token: "oauth2_refresh_token",
            expires_at: NaiveDateTime.add(NaiveDateTime.utc_now(), 30)
          )

        assert {:ok, "new_access_token"} = GenServer.call(Client, :access_token)
        assert {:ok, %{expires_at: %DateTime{}}} = Client.get_token_info()
      end
    end

    test "calls on_refresh with the rotated tokens" do
      test_pid = self()
      # Response omits refresh_token: the old one is kept, and nothing raises
      response = %Req.Response{status: 200, body: %{access_token: "new_access_token", expires_in: 86_400}}

      with_mock Req, [:passthrough], post: fn _url, _opts -> {:ok, response} end do
        :ok =
          Client.set_auth_config(
            access_token: "old_access_token",
            refresh_token: "oauth2_refresh_token",
            on_refresh: &send(test_pid, {:refreshed, &1})
          )

        assert {:ok, %{access_token: "new_access_token"}} = Client.refresh_oauth2_token()
        assert_received {:refreshed, %{access_token: "new_access_token", refresh_token: "oauth2_refresh_token"}}
      end
    end

    test "a map config keeps on_refresh, and token replies leave it out" do
      test_pid = self()
      response = %Req.Response{status: 200, body: %{access_token: "new_access_token", refresh_token: "new_refresh"}}

      with_mock Req, [:passthrough], post: fn _url, _opts -> {:ok, response} end do
        :ok =
          Client.set_auth_config(%{
            access_token: "old_access_token",
            refresh_token: "oauth2_refresh_token",
            expires_at: nil,
            expires_in: nil,
            on_refresh: &send(test_pid, {:refreshed, &1})
          })

        assert {:ok, refreshed} = Client.refresh_oauth2_token()
        assert_received {:refreshed, %{access_token: "new_access_token"}}
        refute Map.has_key?(refreshed, :on_refresh)

        assert {:ok, info} = Client.get_token_info()
        refute Map.has_key?(info, :on_refresh)
      end
    end

    test "a raising on_refresh callback does not crash the client" do
      response = %Req.Response{status: 200, body: %{access_token: "new_access_token", refresh_token: "new_refresh"}}
      pid = Process.whereis(Client)

      with_mock Req, [:passthrough], post: fn _url, _opts -> {:ok, response} end do
        :ok =
          Client.set_auth_config(
            access_token: "old_access_token",
            refresh_token: "oauth2_refresh_token",
            on_refresh: fn _tokens -> raise "db down" end
          )

        ExUnit.CaptureLog.capture_log(fn -> assert {:ok, _} = Client.refresh_oauth2_token() end)

        assert Process.whereis(Client) == pid
        assert {:ok, %{access_token: "new_access_token", refresh_token: "new_refresh"}} = Client.get_token_info()
      end
    end

    test "handles token refresh error" do
      error_response = %Req.Response{
        status: 400,
        body: %{
          error: "invalid_grant",
          error_description: "The provided authorization grant is invalid"
        }
      }

      with_mock Req, [:passthrough], post: fn _url, _opts -> {:ok, error_response} end do
        # First update to an invalid refresh token
        assert GenServer.stop(Client)

        auth_config = [
          access_token: "old_access_token",
          refresh_token: "invalid_refresh_token",
          expires_at: NaiveDateTime.add(NaiveDateTime.utc_now(), 86_400),
          expires_in: 86_400
        ]

        assert {:ok, _pid} = Client.start_link(auth_config)

        assert {:error, {:oauth2_error, 400, _body}} = Client.refresh_oauth2_token()

        # Verify client state wasn't changed
        assert {:ok, current_token_info} = Client.get_token_info()
        assert current_token_info.access_token == "old_access_token"
        assert current_token_info.refresh_token == "invalid_refresh_token"
      end
    end
  end

  describe "OAuth2 token refresh for non-OAuth2 clients" do
    test "returns error when no refresh token available" do
      assert {:ok, _pid} = Client.start_link("bearer_token")
      assert {:error, :no_refresh_token} = Client.refresh_oauth2_token()
    end

    test "returns error for OAuth2 client without refresh token" do
      auth_config = [
        access_token: "oauth2_access_token"
      ]

      assert {:ok, _pid} = Client.start_link(auth_config)

      assert {:error, :no_refresh_token} = Client.refresh_oauth2_token()
    end
  end

  describe "get_token_info/0" do
    test "returns token info for bearer token" do
      assert {:ok, _pid} = Client.start_link("bearer_token")

      assert {:ok, token_info} = Client.get_token_info()
      assert token_info.access_token == "bearer_token"
      assert token_info.refresh_token == nil
      assert token_info.auth_type == :bearer
    end

    test "returns token info for OAuth2 tokens" do
      auth_config = [
        access_token: "oauth2_access_token",
        refresh_token: "oauth2_refresh_token",
        expires_at: NaiveDateTime.add(NaiveDateTime.utc_now(), 86_400),
        expires_in: 86_400
      ]

      assert {:ok, _pid} = Client.start_link(auth_config)

      assert {:ok, token_info} = Client.get_token_info()
      assert token_info.access_token == "oauth2_access_token"
      assert token_info.refresh_token == "oauth2_refresh_token"
      assert token_info.auth_type == :oauth2
    end
  end
end
