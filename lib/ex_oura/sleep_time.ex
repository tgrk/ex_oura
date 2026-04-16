defmodule ExOura.SleepTime do
  @moduledoc """
  Documentation for Oura API - Sleep Time
  """

  alias ExOura.Client

  @type start_date :: Date.t()
  @type end_date :: Date.t()
  @type next_token :: String.t() | nil
  @type document_id :: String.t()
  @type opts :: Keyword.t()
  @type sleep_time_response ::
          {:ok, Client.MultiDocumentResponsePublicSleepTime.t()} | {:error, term()}
  @type single_sleep_time_response :: {:ok, Client.PublicSleepTime.t()} | {:error, term()}

  @doc """
  Multiple Sleep Time
  """
  @spec multiple_sleep_time(start_date(), end_date(), next_token(), opts()) :: sleep_time_response()
  def multiple_sleep_time(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.SleepTimeRoutes,
      :multiple_sleep_time_documents_v2_usercollection_sleep_time_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Sleep Time
  """
  @spec single_sleep_time(document_id(), opts()) :: single_sleep_time_response()
  def single_sleep_time(document_id, opts \\ []) do
    Client.call_api(
      Client.SleepTimeRoutes,
      :single_sleep_time_document_v2_usercollection_sleep_time_document_id_get,
      document_id,
      opts
    )
  end
end
