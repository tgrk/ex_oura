defmodule ExOura.Client.PersonalInfoRoutes do
  @moduledoc """
  Provides API endpoint related to personal info routes
  """

  @default_client ExOura.Client

  @doc """
  Single Personal Info Document
  """
  @spec single_personal_info_document_v2_usercollection_personal_info_get(keyword) ::
          {:ok, ExOura.Client.PersonalInfoResponse.t()} | :error
  def single_personal_info_document_v2_usercollection_personal_info_get(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call:
        {ExOura.Client.PersonalInfoRoutes,
         :single_personal_info_document_v2_usercollection_personal_info_get},
      url: "/v2/usercollection/personal_info",
      method: :get,
      response: [
        {200, {ExOura.Client.PersonalInfoResponse, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {429, :null}
      ],
      opts: opts
    })
  end
end
