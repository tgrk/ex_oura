defmodule ExOura.ClientOAuth2Test do
  use ExUnit.Case, async: false

  import Mock

  alias ExOura.Client

  setup do
    # Stop any existing client
    if Process.whereis(Client) do
      GenServer.stop(Client)
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
      Application.put_env(:ex_oura, :oauth2,
        client_id: "test_client_id",
        client_secret: "test_client_secret",
        redirect_uri: "http://localhost:3000/callback"
      )

      auth_config = [
        access_token: "old_access_token",
        refresh_token: "oauth2_refresh_token"
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
        {:ok, current_token_info} = Client.get_token_info()
        assert current_token_info.access_token == new_token_info.access_token
        assert current_token_info.refresh_token == new_token_info.refresh_token
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
        GenServer.stop(Client)

        auth_config = [
          access_token: "old_access_token",
          refresh_token: "invalid_refresh_token"
        ]

        {:ok, _pid} = Client.start_link(auth_config)

        assert {:error, {:oauth2_error, 400, _body}} = Client.refresh_oauth2_token()

        # Verify client state wasn't changed
        {:ok, current_token_info} = Client.get_token_info()
        assert current_token_info.access_token == "old_access_token"
        assert current_token_info.refresh_token == "invalid_refresh_token"
      end
    end
  end

  describe "OAuth2 token refresh for non-OAuth2 clients" do
    test "returns error when no refresh token available" do
      # Start client with bearer token only
      {:ok, _pid} = Client.start_link("bearer_token")

      assert {:error, :no_refresh_token} = Client.refresh_oauth2_token()
    end

    test "returns error for OAuth2 client without refresh token" do
      auth_config = [access_token: "oauth2_access_token"]
      {:ok, _pid} = Client.start_link(auth_config)

      assert {:error, :no_refresh_token} = Client.refresh_oauth2_token()
    end
  end

  describe "get_token_info/0" do
    test "returns token info for bearer token" do
      {:ok, _pid} = Client.start_link("bearer_token")

      {:ok, token_info} = Client.get_token_info()
      assert token_info.access_token == "bearer_token"
      assert token_info.refresh_token == nil
      assert token_info.auth_type == :bearer
    end

    test "returns token info for OAuth2 tokens" do
      auth_config = [
        access_token: "oauth2_access_token",
        refresh_token: "oauth2_refresh_token"
      ]

      {:ok, _pid} = Client.start_link(auth_config)

      {:ok, token_info} = Client.get_token_info()
      assert token_info.access_token == "oauth2_access_token"
      assert token_info.refresh_token == "oauth2_refresh_token"
      assert token_info.auth_type == :oauth2
    end
  end
end
