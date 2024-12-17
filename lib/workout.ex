defmodule ExOura.Workout do
  @moduledoc """
  Documentation for Oura API - Workout
  """

  alias ExOura.Client

  @doc """
  Multiple Workout
  """
  def multiple_workout(start_date, end_date, next_token \\ nil, opts \\ []) do
    Client.call_api(
      Client.WorkoutRoutes,
      :multiple_workout_documents_v2_usercollection_workout_get,
      [],
      Client.date_range_args(start_date, end_date, next_token) ++ opts
    )
  end

  @doc """
  Single Workout
  """
  def single_workout(document_id, opts \\ []) do
    Client.call_api(
      Client.WorkoutRoutes,
      :single_workout_document_v2_usercollection_workout_document_id_get,
      document_id,
      opts
    )
  end
end
