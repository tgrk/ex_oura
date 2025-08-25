defmodule ExOura.Client.PersonalInfoRoutes do
  @moduledoc false
  alias ExOura.Client.PersonalInfoResponse

  @default_client ExOura.Client

  @doc """
  Single Personal Info Document
  """
  @spec single_personal_info_document_v2_usercollection_personal_info_get(keyword) ::
          {:ok, PersonalInfoResponse.t()} | :error
  def single_personal_info_document_v2_usercollection_personal_info_get(opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [],
      call: {ExOura.Client.PersonalInfoRoutes, :single_personal_info_document_v2_usercollection_personal_info_get},
      url: "/v2/usercollection/personal_info",
      method: :get,
      response: [
        {200, {PersonalInfoResponse, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {429, :null}
      ],
      opts: opts
    })
  end
end
