defmodule ExOura.Client.WorkoutRoutes do
  @moduledoc """
  Provides API endpoints related to workout routes
  """

  alias ExOura.Client.HTTPValidationError
  alias ExOura.Client.MultiDocumentResponseWorkoutModel
  alias ExOura.Client.WorkoutModel
  alias ExOura.Client.WorkoutRoutes

  @default_client ExOura.Client

  @doc """
  Multiple Workout Documents

  ## Options

    * `start_date`
    * `end_date`
    * `next_token`

  """
  @spec multiple_workout_documents_v2_usercollection_workout_get(keyword) ::
          {:ok, MultiDocumentResponseWorkoutModel.t()}
          | {:error, HTTPValidationError.t()}
  def multiple_workout_documents_v2_usercollection_workout_get(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:end_date, :next_token, :start_date])

    client.request(%{
      args: [],
      call: {WorkoutRoutes, :multiple_workout_documents_v2_usercollection_workout_get},
      url: "/v2/usercollection/workout",
      method: :get,
      query: query,
      response: [
        {200, {MultiDocumentResponseWorkoutModel, :t}},
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
  Single Workout Document
  """
  @spec single_workout_document_v2_usercollection_workout_document_id_get(String.t(), keyword) ::
          {:ok, WorkoutModel.t()} | {:error, HTTPValidationError.t()}
  def single_workout_document_v2_usercollection_workout_document_id_get(document_id, opts \\ []) do
    client = opts[:client] || @default_client

    client.request(%{
      args: [document_id: document_id],
      call: {WorkoutRoutes, :single_workout_document_v2_usercollection_workout_document_id_get},
      url: "/v2/usercollection/workout/#{document_id}",
      method: :get,
      response: [
        {200, {WorkoutModel, :t}},
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
