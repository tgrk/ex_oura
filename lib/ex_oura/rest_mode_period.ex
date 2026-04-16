defmodule ExOura.RestModePeriod do
  @moduledoc """
  Documentation for Oura API - Rest Mode Period
  """

  alias ExOura.Client

  @type start_date :: Date.t()
  @type end_date :: Date.t()
  @type next_token :: String.t() | nil
  @type document_id :: String.t()
  @type opts :: Keyword.t()
  @type rest_mode_period_response ::
          {:ok, Client.MultiDocumentResponsePublicRestModePeriod.t()} | {:error, term()}
  @type single_rest_mode_period_response :: {:ok, Client.PublicRestModePeriod.t()} | {:error, term()}

  @doc """
  Multiple Rest Mode Period
  """
  @spec multiple_rest_mode_period(start_date(), end_date(), next_token(), opts()) ::
          rest_mode_period_response()
  def multiple_rest_mode_period(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.RestModePeriodRoutes,
      :multiple_rest_mode_period_documents_v2_usercollection_rest_mode_period_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Rest Mode Period
  """
  @spec single_rest_mode_period(document_id(), opts()) :: single_rest_mode_period_response()
  def single_rest_mode_period(document_id, opts \\ []) do
    Client.call_api(
      Client.RestModePeriodRoutes,
      :single_rest_mode_period_document_v2_usercollection_rest_mode_period_document_id_get,
      document_id,
      opts
    )
  end
end
