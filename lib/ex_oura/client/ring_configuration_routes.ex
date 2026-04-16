defmodule ExOura.Client.RingConfigurationRoutes do
  @moduledoc """
  Provides API endpoints related to ring configuration routes
  """

  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponsePublicRingConfiguration
  alias ExOura.Client.PublicRingConfiguration
  alias ExOura.Client.RingConfigurationRoutes

  @default_client ExOura.Client

  @doc """
  Multiple Ring Configuration Documents

  ## Options

    * `fields`: Comma-separated list of fields to include in the response, in addition to the always returned fields. Defaults to all fields if not provided.
    * `next_token`

  """
  @spec multiple_ring_configuration_documents_v2_usercollection_ring_configuration_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicRingConfiguration.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_ring_configuration_documents_v2_usercollection_ring_configuration_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:fields, :next_token])

    client.request(%{
      args: [],
      call: {RingConfigurationRoutes, :multiple_ring_configuration_documents_v2_usercollection_ring_configuration_get},
      url: "/v2/usercollection/ring_configuration",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicRingConfiguration, :t}
          ]}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Single Ring Configuration Document
  """
  @spec single_ring_configuration_document_v2_usercollection_ring_configuration_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicRingConfiguration.t()}
          | {:error, HTTPValidationError.t()}
  def single_ring_configuration_document_v2_usercollection_ring_configuration_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {RingConfigurationRoutes,
         :single_ring_configuration_document_v2_usercollection_ring_configuration_document_id_get},
      url: "/v2/usercollection/ring_configuration/#{document_id}",
      method: :get,
      response: [
        {200, {PublicRingConfiguration, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end
end
