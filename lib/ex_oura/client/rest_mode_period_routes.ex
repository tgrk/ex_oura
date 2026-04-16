defmodule ExOura.Client.RestModePeriodRoutes do
  @moduledoc """
  Provides API endpoints related to rest mode period routes
  """

  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponsePublicRestModePeriod
  alias ExOura.Client.PublicRestModePeriod
  alias ExOura.Client.RestModePeriodRoutes

  @default_client ExOura.Client

  @doc """
  Multiple Rest Mode Period Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`
    * `fields`: Comma-separated list of fields to include in the response, in addition to the always returned fields. Defaults to all fields if not provided.

  """
  @spec multiple_rest_mode_period_documents_v2_usercollection_rest_mode_period_get(opts :: keyword) ::
          {:ok,
           MultiDocumentResponseDict.t()
           | MultiDocumentResponsePublicRestModePeriod.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_rest_mode_period_documents_v2_usercollection_rest_mode_period_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :fields, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {RestModePeriodRoutes, :multiple_rest_mode_period_documents_v2_usercollection_rest_mode_period_get},
      url: "/v2/usercollection/rest_mode_period",
      method: :get,
      query: query,
      response: [
        {200,
         {:union,
          [
            {MultiDocumentResponseDict, :t},
            {MultiDocumentResponsePublicRestModePeriod, :t}
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
  Single Rest Mode Period Document
  """
  @spec single_rest_mode_period_document_v2_usercollection_rest_mode_period_document_id_get(
          document_id :: String.t(),
          opts :: keyword
        ) ::
          {:ok, PublicRestModePeriod.t()}
          | {:error, HTTPValidationError.t()}
  def single_rest_mode_period_document_v2_usercollection_rest_mode_period_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {RestModePeriodRoutes, :single_rest_mode_period_document_v2_usercollection_rest_mode_period_document_id_get},
      url: "/v2/usercollection/rest_mode_period/#{document_id}",
      method: :get,
      response: [
        {200, {PublicRestModePeriod, :t}},
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
