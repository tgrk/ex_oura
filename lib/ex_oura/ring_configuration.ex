defmodule ExOura.RingConfiguration do
  @moduledoc """
  Documentation for Oura API - Ring Configuration
  """

  alias ExOura.Client

  @type start_date :: Date.t()
  @type end_date :: Date.t()
  @type next_token :: String.t() | nil
  @type document_id :: String.t()
  @type opts :: Keyword.t()
  @type public_ring_configuration_response ::
          {:ok, Client.MultiDocumentResponsePublicRingConfiguration.t()} | {:error, term()}
  @type single_ring_configuration_response ::
          {:ok, Client.PublicRingConfiguration.t()} | {:error, term()}

  @doc """
  Multiple Ring Configuration
  """
  @spec multiple_ring_configuration(start_date(), end_date(), next_token(), opts()) ::
          public_ring_configuration_response()
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
  @spec single_ring_configuration(document_id(), opts()) :: single_ring_configuration_response()
  def single_ring_configuration(document_id, opts \\ []) do
    Client.call_api(
      Client.RingConfigurationRoutes,
      :single_ring_configuration_document_v2_usercollection_ring_configuration_document_id_get,
      document_id,
      opts
    )
  end
end
