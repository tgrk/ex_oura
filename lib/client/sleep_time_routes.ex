defmodule ExOura.Client.SleepTimeRoutes do
  @moduledoc """
  Provides API endpoints related to sleep time routes
  """

  @default_client ExOura.Client

  @doc """
  Multiple Sleep Time Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_sleep_time_documents_v2_usercollection_sleep_time_get(keyword) ::
          {:ok, ExOura.Client.MultiDocumentResponseSleepTimeModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def multiple_sleep_time_documents_v2_usercollection_sleep_time_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call:
        {ExOura.Client.SleepTimeRoutes,
         :multiple_sleep_time_documents_v2_usercollection_sleep_time_get},
      url: "/v2/usercollection/sleep_time",
      method: :get,
      query: query,
      response: [
        {200, {ExOura.Client.MultiDocumentResponseSleepTimeModel, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {422, {ExOura.Client.HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end

  @doc """
  Single Sleep Time Document
  """
  @spec single_sleep_time_document_v2_usercollection_sleep_time_document_id_get(
          String.t(),
          keyword
        ) ::
          {:ok, ExOura.Client.SleepTimeModel.t()}
          | {:error, ExOura.Client.HTTPValidationError.t()}
  def single_sleep_time_document_v2_usercollection_sleep_time_document_id_get(
        document_id,
        opts \\ []
      ) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call:
        {ExOura.Client.SleepTimeRoutes,
         :single_sleep_time_document_v2_usercollection_sleep_time_document_id_get},
      url: "/v2/usercollection/sleep_time/#{document_id}",
      method: :get,
      response: [
        {200, {ExOura.Client.SleepTimeModel, :t}},
        {400, :null},
        {401, :null},
        {403, :null},
        {404, :null},
        {422, {ExOura.Client.HTTPValidationError, :t}},
        {429, :null}
      ],
      opts: opts
    })
  end
end