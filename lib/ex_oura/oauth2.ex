defmodule ExOura.OAuth2 do
  @moduledoc """
  OAuth2 flow implementation for Oura API v2.

  Provides functions for OAuth2 authorization code flow including:
  - Authorization URL generation
  - Token exchange (authorization code for access token)
  - Token refresh
  - Token storage and retrieval

  ## Configuration

  Configure your OAuth2 application credentials:

      config :ex_oura,
        oauth2: [
          client_id: "your_client_id",
          client_secret: "your_client_secret",
          redirect_uri: "your_redirect_uri"
        ]

  Or set them as environment variables:
  - `OURA_CLIENT_ID`
  - `OURA_CLIENT_SECRET`
  - `OURA_REDIRECT_URI`

  ## Usage

  ### Step 1: Generate authorization URL

      authorization_url = ExOura.OAuth2.authorization_url([
        scopes: ["daily", "heartrate", "personal"],
        state: "your_state_parameter"
      ])

  ### Step 2: Exchange authorization code for tokens

      {:ok, tokens} = ExOura.OAuth2.get_token("authorization_code_from_callback")

  ### Step 3: Use the access token with the client

      {:ok, client} = ExOura.Client.start_link(tokens.access_token)

  ### Step 4: Refresh tokens when they expire

      {:ok, new_tokens} = ExOura.OAuth2.refresh_token(tokens.refresh_token)

  ## Available Scopes

  - `email` - Email address of the user
  - `personal` - Personal information (gender, age, height, weight)
  - `daily` - Daily summaries of sleep, activity and readiness
  - `heartrate` - Time series heart rate for Gen 3 users
  - `workout` - Summaries for auto-detected and user entered workouts
  - `tag` - User entered tags
  - `session` - Guided and unguided sessions in the Oura app
  - `spo2` - SpO2 Average recorded during sleep (in doc mistakely as spo2Daily!)

  ## Token Structure

  Tokens are returned as a map with the following structure:

      %{
        access_token: "access_token",
        refresh_token: "refresh_token",
        token_type: "Bearer",
        expires_in: 86400,
        expires_at: ~U[2025-08-26 12:00:00Z],
        scope: "daily heartrate personal"
      }

  """

  @base_auth_url "https://cloud.ouraring.com/oauth/authorize"
  @token_url "https://api.ouraring.com/oauth/token"

  @default_scopes ["personal", "daily"]
  @all_scopes [
    "email",
    "personal",
    "daily",
    "heartrate",
    "workout",
    "tag",
    "session",
    "spo2"
  ]

  @type scope :: String.t()
  @type scopes :: [scope()]
  @type oauth2_config :: [
          client_id: String.t(),
          client_secret: String.t(),
          redirect_uri: String.t()
        ]
  @type token_response :: %{
          access_token: String.t(),
          refresh_token: String.t() | nil,
          token_type: String.t(),
          expires_in: integer(),
          expires_at: DateTime.t(),
          scope: String.t()
        }
  @type authorization_options :: [
          scopes: scopes(),
          state: String.t() | nil
        ]

  @doc """
  Generates the OAuth2 authorization URL to redirect users to.

  ## Options

  - `:scopes` - List of scopes to request (defaults to #{inspect(@default_scopes)})
  - `:state` - State parameter for CSRF protection (recommended)

  ## Examples

      iex> ExOura.OAuth2.authorization_url()
      "https://cloud.ouraring.com/oauth/authorize?client_id=your_id&redirect_uri=your_uri&response_type=code&scope=personal+daily"

      iex> ExOura.OAuth2.authorization_url(scopes: ["daily", "heartrate"], state: "random_state")
      "https://cloud.ouraring.com/oauth/authorize?client_id=your_id&redirect_uri=your_uri&response_type=code&scope=daily+heartrate&state=random_state"

  """
  @spec authorization_url(authorization_options()) :: String.t()
  def authorization_url(opts \\ []) do
    config = get_config()
    scopes = Keyword.get(opts, :scopes, @default_scopes)
    state = Keyword.get(opts, :state)

    validate_scopes!(scopes)

    query_params = %{
      client_id: config[:client_id],
      redirect_uri: config[:redirect_uri],
      response_type: "code",
      scope: Enum.join(scopes, " ")
    }

    query_params =
      if state do
        Map.put(query_params, :state, state)
      else
        query_params
      end

    "#{@base_auth_url}?#{URI.encode_query(query_params)}"
  end

  @doc """
  Exchanges an authorization code for access and refresh tokens.

  ## Parameters

  - `code` - The authorization code received from the callback
  - `opts` - Additional options (currently unused)

  ## Returns

  `{:ok, tokens}` on success or `{:error, reason}` on failure.

  ## Examples

      {:ok, tokens} = ExOura.OAuth2.get_token("authorization_code_from_callback")

      tokens.access_token
      # => "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

      tokens.expires_at
      # => ~U[2025-08-26 12:00:00Z]

  """
  @spec get_token(String.t(), Keyword.t()) :: {:ok, token_response()} | {:error, term()}
  def get_token(code, opts \\ []) do
    config = get_config()

    token_data = %{
      grant_type: "authorization_code",
      code: code,
      client_id: config[:client_id],
      client_secret: config[:client_secret],
      redirect_uri: config[:redirect_uri]
    }

    case make_token_request(token_data, opts) do
      {:ok, response} ->
        {:ok, normalize_token_response(response)}

      error ->
        error
    end
  end

  @doc """
  Refreshes an access token using a refresh token.

  ## Parameters

  - `refresh_token` - The refresh token to use
  - `opts` - Additional options (currently unused)

  ## Returns

  `{:ok, tokens}` on success or `{:error, reason}` on failure.

  ## Examples

      {:ok, new_tokens} = ExOura.OAuth2.refresh_token(old_tokens.refresh_token)

  """
  @spec refresh_token(String.t(), Keyword.t()) :: {:ok, token_response()} | {:error, term()}
  def refresh_token(refresh_token, opts \\ []) do
    config = get_config()

    token_data = %{
      grant_type: "refresh_token",
      refresh_token: refresh_token,
      client_id: config[:client_id],
      client_secret: config[:client_secret]
    }

    case make_token_request(token_data, opts) do
      {:ok, response} ->
        {:ok, normalize_token_response(response)}

      error ->
        error
    end
  end

  @doc """
  Checks if an access token is expired or will expire soon.

  ## Parameters

  - `tokens` - Token map with expires_at field
  - `buffer_seconds` - Seconds before expiry to consider expired (default: 300)

  ## Examples

      ExOura.OAuth2.token_expired?(tokens)
      # => false

      ExOura.OAuth2.token_expired?(tokens, 3600)  # 1 hour buffer
      # => true

  """
  @spec token_expired?(token_response(), integer()) :: boolean()
  def token_expired?(tokens, buffer_seconds \\ 300) do
    expires_at = Map.get(tokens, :expires_at)

    if expires_at do
      buffer_time = DateTime.add(DateTime.utc_now(), buffer_seconds)
      DateTime.before?(expires_at, buffer_time)
    else
      # If no expiry time, assume it's expired to be safe
      true
    end
  end

  @doc """
  Returns all available OAuth2 scopes.

  ## Examples

      ExOura.OAuth2.available_scopes()
      # => ["email", "personal", "daily", "heartrate", "workout", "tag", "session", "spo2"]

  """
  @spec available_scopes() :: scopes()
  def available_scopes, do: @all_scopes

  @doc """
  Returns the default OAuth2 scopes used when none are specified.

  ## Examples

      ExOura.OAuth2.default_scopes()
      # => ["personal", "daily"]

  """
  @spec default_scopes() :: scopes()
  def default_scopes, do: @default_scopes

  # Private functions

  defp get_config do
    oauth2_config = Application.get_env(:ex_oura, :oauth2, [])

    client_id = oauth2_config[:client_id] || System.get_env("OURA_CLIENT_ID")
    client_secret = oauth2_config[:client_secret] || System.get_env("OURA_CLIENT_SECRET")
    redirect_uri = oauth2_config[:redirect_uri] || System.get_env("OURA_REDIRECT_URI")

    if is_nil(client_id) or is_nil(client_secret) or is_nil(redirect_uri) do
      raise """
      OAuth2 configuration is incomplete. Please configure:

      config :ex_oura,
        oauth2: [
          client_id: "your_client_id",
          client_secret: "your_client_secret",
          redirect_uri: "your_redirect_uri"
        ]

      Or set environment variables:
      - OURA_CLIENT_ID
      - OURA_CLIENT_SECRET
      - OURA_REDIRECT_URI
      """
    end

    [
      client_id: client_id,
      client_secret: client_secret,
      redirect_uri: redirect_uri
    ]
  end

  defp validate_scopes!(scopes) do
    invalid_scopes = scopes -- @all_scopes

    if length(invalid_scopes) > 0 do
      raise ArgumentError, """
      Invalid OAuth2 scopes: #{inspect(invalid_scopes)}

      Available scopes: #{inspect(@all_scopes)}
      """
    end
  end

  defp make_token_request(token_data, opts) do
    timeout = Keyword.get(opts, :timeout, 10_000)

    case Req.post(@token_url,
           form: token_data,
           decode_json: [keys: :atoms],
           retry: false,
           connect_options: [timeout: timeout]
         ) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error, {:oauth2_error, status, body}}

      {:error, _} = error ->
        error
    end
  end

  defp normalize_token_response(response) do
    expires_in = Map.get(response, :expires_in)

    expires_at =
      if expires_in do
        DateTime.add(DateTime.utc_now(), expires_in)
      end

    response
    |> Map.put(:expires_at, expires_at)
    |> Map.put(:token_type, Map.get(response, :token_type, "Bearer"))
  end
end
