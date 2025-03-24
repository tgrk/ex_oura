defmodule ExOura.Test.Support.Case do
  @moduledoc false
  use ExUnit.CaseTemplate

  setup_all do
    # Setup ExVCR
    Finch.start_link(name: ExOuraMockClient)

    # Start ExOura client
    access_token =
      System.get_env("OURA_ACCESS_TOKEN") ||
        raise """
        environment variable OURA_ACCESS_TOKEN is missing.
        See https://cloud.ouraring.com/personal-access-tokens for more details
        """

    case Process.whereis(ExOura.Client) do
      nil ->
        ExOura.Client.start_link(access_token)

      pid ->
        {:ok, pid}
    end

    :ok
  end
end
