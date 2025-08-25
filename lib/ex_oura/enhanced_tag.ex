defmodule ExOura.EnhancedTag do
  @moduledoc """
  Documentation for Oura API - Enhanced Tag
  """

  alias ExOura.Client

  @doc """
  Multiple Enhanced Tag
  """
  def multiple_enhanced_tag(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.EnhancedTagRoutes,
      :multiple_enhanced_tag_documents_v2_usercollection_enhanced_tag_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Enhanced Tag
  """
  def single_enhanced_tag(document_id, opts \\ []) do
    Client.call_api(
      Client.EnhancedTagRoutes,
      :single_enhanced_tag_document_v2_usercollection_enhanced_tag_document_id_get,
      document_id,
      opts
    )
  end
end
