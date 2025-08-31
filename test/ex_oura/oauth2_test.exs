defmodule ExOura.OAuth2Test do
  use ExUnit.Case, async: true

  import Mock

  alias ExOura.OAuth2

  describe "configuration" do
    test "raises error when OAuth2 configuration is missing" do
      # Clear configuration temporarily
      original_config = Application.get_env(:ex_oura, :oauth2)
      Application.delete_env(:ex_oura, :oauth2)

      # Clear environment variables
      original_env = %{
        client_id: System.get_env("OURA_CLIENT_ID"),
        client_secret: System.get_env("OURA_CLIENT_SECRET"),
        redirect_uri: System.get_env("OURA_REDIRECT_URI")
      }

      System.delete_env("OURA_CLIENT_ID")
      System.delete_env("OURA_CLIENT_SECRET")
      System.delete_env("OURA_REDIRECT_URI")

      assert_raise RuntimeError, ~r/OAuth2 configuration is incomplete/, fn ->
        OAuth2.authorization_url()
      end

      # Restore configuration
      if original_config do
        Application.put_env(:ex_oura, :oauth2, original_config)
      end

      # Restore environment variables
      Enum.each(original_env, fn {key, value} ->
        if value do
          env_key = key |> Atom.to_string() |> String.upcase()
          env_key = String.replace_prefix(env_key, "", "OURA_")
          System.put_env(env_key, value)
        end
      end)
    end
  end

  describe "authorization_url/1" do
    setup do
      Application.put_env(:ex_oura, :oauth2,
        client_id: "test_client_id",
        client_secret: "test_client_secret",
        redirect_uri: "http://localhost:3000/callback"
      )

      :ok
    end

    test "generates authorization URL with default scopes" do
      url = OAuth2.authorization_url()
      uri = URI.parse(url)
      query_params = URI.decode_query(uri.query)

      assert uri.scheme == "https"
      assert uri.host == "cloud.ouraring.com"
      assert uri.path == "/oauth/authorize"
      assert query_params["client_id"] == "test_client_id"
      assert query_params["redirect_uri"] == "http://localhost:3000/callback"
      assert query_params["response_type"] == "code"
      assert query_params["scope"] == "personal daily"
    end

    test "generates authorization URL with custom scopes" do
      url = OAuth2.authorization_url(scopes: ["daily", "heartrate"])
      uri = URI.parse(url)
      query_params = URI.decode_query(uri.query)

      assert query_params["scope"] == "daily heartrate"
    end

    test "generates authorization URL with state parameter" do
      url = OAuth2.authorization_url(state: "random_state_123")
      uri = URI.parse(url)
      query_params = URI.decode_query(uri.query)

      assert query_params["state"] == "random_state_123"
    end

    test "raises error for invalid scopes" do
      assert_raise ArgumentError, ~r/Invalid OAuth2 scopes/, fn ->
        OAuth2.authorization_url(scopes: ["invalid_scope"])
      end
    end
  end

  describe "get_token/2" do
    setup do
      Application.put_env(:ex_oura, :oauth2,
        client_id: "test_client_id",
        client_secret: "test_client_secret",
        redirect_uri: "http://localhost:3000/callback"
      )

      :ok
    end

    test "exchanges authorization code for tokens successfully" do
      successful_response = %Req.Response{
        status: 200,
        body: %{
          access_token: "test_access_token",
          refresh_token: "test_refresh_token",
          token_type: "Bearer",
          expires_in: 86_400,
          scope: "daily personal"
        }
      }

      with_mock Req, [:passthrough], post: fn _url, _opts -> {:ok, successful_response} end do
        code = "test_authorization_code"

        assert {:ok, tokens} = OAuth2.get_token(code)
        assert tokens.access_token == "test_access_token"
        assert tokens.refresh_token == "test_refresh_token"
        assert tokens.token_type == "Bearer"
        assert tokens.expires_in == 86_400
        assert %DateTime{} = tokens.expires_at
      end
    end

    test "handles token exchange error" do
      error_response = %Req.Response{
        status: 400,
        body: %{
          error: "invalid_grant",
          error_description: "The provided authorization grant is invalid"
        }
      }

      with_mock Req, [:passthrough], post: fn _url, _opts -> {:ok, error_response} end do
        code = "invalid_authorization_code"

        assert {:error, {:oauth2_error, 400, _body}} = OAuth2.get_token(code)
      end
    end
  end

  describe "refresh_token/2" do
    setup do
      Application.put_env(:ex_oura, :oauth2,
        client_id: "test_client_id",
        client_secret: "test_client_secret",
        redirect_uri: "http://localhost:3000/callback"
      )

      :ok
    end

    test "refreshes token successfully" do
      successful_response = %Req.Response{
        status: 200,
        body: %{
          access_token: "new_access_token",
          refresh_token: "new_refresh_token",
          token_type: "Bearer",
          expires_in: 86_400,
          scope: "daily personal"
        }
      }

      with_mock Req, [:passthrough], post: fn _url, _opts -> {:ok, successful_response} end do
        refresh_token = "test_refresh_token"

        assert {:ok, new_tokens} = OAuth2.refresh_token(refresh_token)
        assert new_tokens.access_token == "new_access_token"
        assert new_tokens.refresh_token == "new_refresh_token"
        assert new_tokens.token_type == "Bearer"
        assert new_tokens.expires_in == 86_400
        assert %DateTime{} = new_tokens.expires_at
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
        refresh_token = "invalid_refresh_token"

        assert {:error, {:oauth2_error, 400, _body}} = OAuth2.refresh_token(refresh_token)
      end
    end
  end

  describe "token_expired?/2" do
    test "returns true for expired token" do
      expired_token = %{
        access_token: "token",
        # 1 hour ago
        expires_at: DateTime.add(DateTime.utc_now(), -3600)
      }

      assert OAuth2.token_expired?(expired_token) == true
    end

    test "returns false for valid token" do
      valid_token = %{
        access_token: "token",
        # 1 hour from now
        expires_at: DateTime.add(DateTime.utc_now(), 3600)
      }

      assert OAuth2.token_expired?(valid_token) == false
    end

    test "returns true for token expiring soon with buffer" do
      soon_to_expire = %{
        access_token: "token",
        # 200 seconds from now
        expires_at: DateTime.add(DateTime.utc_now(), 200)
      }

      # 5 minute buffer
      assert OAuth2.token_expired?(soon_to_expire, 300) == true
    end

    test "returns true when expires_at is nil" do
      token_without_expiry = %{access_token: "token"}

      assert OAuth2.token_expired?(token_without_expiry) == true
    end
  end

  describe "available_scopes/0" do
    test "returns all available scopes" do
      scopes = OAuth2.available_scopes()

      expected_scopes = [
        "email",
        "personal",
        "daily",
        "heartrate",
        "workout",
        "tag",
        "session",
        "spo2"
      ]

      assert scopes == expected_scopes
    end
  end

  describe "default_scopes/0" do
    test "returns default scopes" do
      scopes = OAuth2.default_scopes()
      assert scopes == ["personal", "daily"]
    end
  end
end
