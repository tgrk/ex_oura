defmodule ExOura.Vo2Max do
  @moduledoc """
  Documentation for Oura API - Vo2 Max
  """

  alias ExOura.Client

  @type start_date :: Date.t()
  @type end_date :: Date.t()
  @type next_token :: String.t() | nil
  @type document_id :: String.t()
  @type opts :: Keyword.t()
  @type vo2_max_response :: {:ok, Client.MultiDocumentResponsePublicVo2Max.t()} | {:error, term()}
  @type single_vo2_max_response :: {:ok, Client.PublicVo2Max.t()} | {:error, term()}

  @doc """
  Multiple Vo2 Max
  """
  @spec multiple_vo2_max(start_date(), end_date(), next_token(), opts()) :: vo2_max_response()
  def multiple_vo2_max(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.Vo2MaxRoutes,
      :multiple_v_o2_max_documents_v2_usercollection_v_o2_max_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Vo2 Max
  """
  @spec single_vo2_max(document_id(), opts()) :: single_vo2_max_response()
  def single_vo2_max(document_id, opts \\ []) do
    Client.call_api(
      Client.Vo2MaxRoutes,
      :single_v_o2_max_document_v2_usercollection_v_o2_max_document_id_get,
      document_id,
      opts
    )
  end
end
