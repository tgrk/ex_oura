defmodule ExOura.RingConfiguration do
  @moduledoc """
  Documentation for Oura API - Ring Configuration
  """

  alias ExOura.Client

  @doc """
  Multiple Ring Configuration
  """
  def multiple_ring_configuration(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.RingConfigurationRoutes,
      :multiple_ring_configuration_documents_v2_usercollection_ring_configuration_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Ring Configuration
  """
  def single_ring_configuration(document_id, opts \\ []) do
    Client.call_api(
      Client.RingConfigurationRoutes,
      :single_ring_configuration_document_v2_usercollection_ring_configuration_document_id_get,
      document_id,
      opts
    )
  end
end
