defmodule ExOura.Tag do
  @moduledoc """
  Tag API operations for the deprecated Tag endpoints.

  Note: Tag endpoints are deprecated. Use Enhanced Tags instead.
  """

  alias ExOura.Client

  @type opts() :: Keyword.t()
  @type start_date() :: Date.t()
  @type end_date() :: Date.t()
  @type next_token() :: String.t() | nil
  @type document_id() :: String.t()

  @doc """
  Multiple Tag Documents

  Note: This endpoint is deprecated. Use Enhanced Tags instead.
  """
  @spec multiple_tag(start_date(), end_date(), next_token(), opts()) ::
          {:ok, Client.MultiDocumentResponseTagModel.t()}
          | {:error, Client.HTTPValidationError.t()}
  def multiple_tag(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.TagRoutes.multiple_tag_documents_v2_usercollection_tag_get(
      Keyword.merge(opts,
        start_date: start_date,
        end_date: end_date,
        next_token: next_token
      )
    )
  end

  @doc """
  Single Tag Document

  Note: This endpoint is deprecated. Use Enhanced Tags instead.
  """
  @spec single_tag(document_id(), opts()) ::
          {:ok, Client.TagModel.t()}
          | {:error, Client.HTTPValidationError.t()}
  def single_tag(document_id, opts \\ []) do
    Client.TagRoutes.single_tag_document_v2_usercollection_tag_document_id_get(
      document_id,
      opts
    )
  end
end
