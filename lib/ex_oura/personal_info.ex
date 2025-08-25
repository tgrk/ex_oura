defmodule ExOura.PersonalInfo do
  @moduledoc """
  Documentation for Oura API - Personal Info
  """

  alias ExOura.Client

  @doc """
  Single Personal Info
  """
  def single_personal_info(opts \\ []) do
    Client.call_api(
      Client.PersonalInfoRoutes,
      :single_personal_info_document_v2_usercollection_personal_info_get,
      [],
      opts
    )
  end
end
