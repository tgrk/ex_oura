defmodule ExOura.Sleep do
  @moduledoc """
  Documentation for Oura API - Sleep
  """

  alias ExOura.Client

  @type start_date :: Date.t()
  @type end_date :: Date.t()
  @type next_token :: String.t() | nil
  @type document_id :: String.t()
  @type opts :: Keyword.t()
  @type sleep_response ::
          {:ok, Client.MultiDocumentResponsePublicModifiedSleepModel.t()} | {:error, term()}
  @type single_sleep_response :: {:ok, Client.PublicModifiedSleepModel.t()} | {:error, term()}

  @doc """
  Multiple Sleep
  """
  @spec multiple_sleep(start_date(), end_date(), next_token(), opts()) :: sleep_response()
  def multiple_sleep(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.SleepRoutes,
      :multiple_sleep_documents_v2_usercollection_sleep_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Sleep
  """
  @spec single_sleep(document_id(), opts()) :: single_sleep_response()
  def single_sleep(document_id, opts \\ []) do
    Client.call_api(
      Client.SleepRoutes,
      :single_sleep_document_v2_usercollection_sleep_document_id_get,
      document_id,
      opts
    )
  end
end
