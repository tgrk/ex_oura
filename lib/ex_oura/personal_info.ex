defmodule ExOura.PersonalInfo do
  @moduledoc """
  API functions for retrieving Oura personal information data.

  Personal information includes user demographics and physical characteristics such as age,
  weight, height, biological sex, and email address. This data requires the "personal" and/or
  "email" OAuth2 scopes.

  ## Required Scopes

  - `personal` - Access to demographic and physical information (age, weight, height, biological_sex)
  - `email` - Access to email address

  ## Data Privacy

  Personal information is sensitive data. Ensure your application:
  - Only requests necessary scopes
  - Handles personal data according to privacy regulations
  - Stores personal data securely if caching is needed
  - Respects user consent and data access preferences

  ## Common Use Cases

  - User profile setup and display
  - Personalized health recommendations based on demographics
  - Account management and verification
  - Health metric calculations that depend on user characteristics
  """

  alias ExOura.Client

  @type opts :: Keyword.t()
  @type personal_info_response :: {:ok, Client.PersonalInfoResponse.t()} | {:error, term()}

  @doc """
  Retrieves the personal information for the authenticated user.

  This endpoint returns demographic and physical information for the current user. The data
  returned depends on the scopes granted during OAuth2 authorization.

  ## Parameters

  - `opts` - Optional keyword list of additional parameters

  ## Options

  - `:timeout` - Request timeout in milliseconds (defaults to configured timeout)

  ## Returns

  - `{:ok, personal_info}` - Success with personal information
  - `{:error, reason}` - Error with details (e.g., insufficient scopes, unauthorized)

  ## Examples

      # Get personal information
      {:ok, info} = ExOura.PersonalInfo.single_personal_info()

      IO.puts("Age: \#{info.age}")
      IO.puts("Weight: \#{info.weight} kg")
      IO.puts("Height: \#{info.height} cm")
      IO.puts("Biological Sex: \#{info.biological_sex}")

      # Handle scope-related errors
      case ExOura.PersonalInfo.single_personal_info() do
        {:ok, info} ->
          display_user_profile(info)
        {:error, %{status: 403}} ->
          IO.puts("Insufficient permissions. Please grant 'personal' scope.")
        {:error, reason} ->
          IO.puts("Failed to fetch personal info: \#{inspect(reason)}")
      end

      # Use with custom timeout
      {:ok, info} = ExOura.PersonalInfo.single_personal_info(timeout: 15_000)

  ## Response Structure

  The response contains:
  - `id` - User identifier
  - `age` - Age in years (requires "personal" scope)
  - `weight` - Weight in kilograms (requires "personal" scope)
  - `height` - Height in centimeters (requires "personal" scope)
  - `biological_sex` - "male" or "female" (requires "personal" scope)
  - `email` - Email address (requires "email" scope)

  ## Scope Requirements

  Fields will be `nil` if the corresponding scope was not granted:
  - Without "personal" scope: age, weight, height, biological_sex will be nil
  - Without "email" scope: email will be nil
  """
  @spec single_personal_info(opts()) :: personal_info_response()
  def single_personal_info(opts \\ []) do
    Client.call_api(
      Client.PersonalInfoRoutes,
      :single_personal_info_document_v2_usercollection_personal_info_get,
      [],
      opts
    )
  end
end
