defmodule ExOuraTest do
  use ExUnit.Case, async: false

  import Mock

  describe "pagination convenience functions" do
    test "all_daily_activity fetches every page through the facade" do
      start_date = ~D[2024-01-01]
      end_date = ~D[2024-01-02]

      with_mock ExOura.DailyActivity, [:passthrough],
        multiple_daily_activity: fn ^start_date, ^end_date, next_token, opts ->
          send(self(), {:multiple_daily_activity, next_token, opts})

          case next_token do
            nil -> {:ok, %{data: [%{id: "page-1"}], next_token: "page-2"}}
            "page-2" -> {:ok, %{data: [%{id: "page-2"}], next_token: nil}}
          end
        end do
        assert {:ok, [%{id: "page-1"}, %{id: "page-2"}]} =
                 ExOura.all_daily_activity(start_date, end_date, fields: "score")

        assert_received {:multiple_daily_activity, nil, [fields: "score"]}
        assert_received {:multiple_daily_activity, "page-2", [fields: "score"]}
      end
    end

    test "all_daily_readiness delegates to the readiness wrapper" do
      with_mock ExOura.DailyReadiness, [:passthrough],
        multiple_daily_readiness: fn ~D[2024-01-01], ~D[2024-01-02], nil, [latest: true] ->
          {:ok, %{data: [%{id: "readiness-1"}], next_token: nil}}
        end do
        assert {:ok, [%{id: "readiness-1"}]} =
                 ExOura.all_daily_readiness(~D[2024-01-01], ~D[2024-01-02], latest: true)
      end
    end

    test "all_daily_sleep delegates to the daily sleep wrapper" do
      with_mock ExOura.DailySleep, [:passthrough],
        multiple_daily_sleep: fn ~D[2024-01-01], ~D[2024-01-02], nil, [] ->
          {:ok, %{data: [%{id: "daily-sleep-1"}], next_token: nil}}
        end do
        assert {:ok, [%{id: "daily-sleep-1"}]} =
                 ExOura.all_daily_sleep(~D[2024-01-01], ~D[2024-01-02])
      end
    end

    test "all_workouts delegates to the workout wrapper" do
      with_mock ExOura.Workout, [:passthrough],
        multiple_workout: fn ~D[2024-01-01], ~D[2024-01-02], nil, [] ->
          {:ok, %{data: [%{id: "workout-1"}], next_token: nil}}
        end do
        assert {:ok, [%{id: "workout-1"}]} = ExOura.all_workouts(~D[2024-01-01], ~D[2024-01-02])
      end
    end

    test "all_sleep delegates to the sleep wrapper" do
      with_mock ExOura.Sleep, [:passthrough],
        multiple_sleep: fn ~D[2024-01-01], ~D[2024-01-02], nil, [] ->
          {:ok, %{data: [%{id: "sleep-1"}], next_token: nil}}
        end do
        assert {:ok, [%{id: "sleep-1"}]} = ExOura.all_sleep(~D[2024-01-01], ~D[2024-01-02])
      end
    end
  end

  describe "stream convenience functions" do
    test "stream_daily_activity streams every page through the facade" do
      start_date = ~D[2024-01-01]
      end_date = ~D[2024-01-02]

      with_mock ExOura.DailyActivity, [:passthrough],
        multiple_daily_activity: fn ^start_date, ^end_date, next_token, [] ->
          case next_token do
            nil -> {:ok, %{data: [%{id: "page-1"}], next_token: "page-2"}}
            "page-2" -> {:ok, %{data: [%{id: "page-2"}], next_token: nil}}
          end
        end do
        assert [%{id: "page-1"}, %{id: "page-2"}] =
                 start_date
                 |> ExOura.stream_daily_activity(end_date)
                 |> Enum.to_list()
      end
    end

    test "stream_workouts streams every page through the facade" do
      start_date = ~D[2024-01-01]
      end_date = ~D[2024-01-02]

      with_mock ExOura.Workout, [:passthrough],
        multiple_workout: fn ^start_date, ^end_date, next_token, [] ->
          case next_token do
            nil -> {:ok, %{data: [%{id: "page-1"}], next_token: "page-2"}}
            "page-2" -> {:ok, %{data: [%{id: "page-2"}], next_token: nil}}
          end
        end do
        assert [%{id: "page-1"}, %{id: "page-2"}] =
                 start_date
                 |> ExOura.stream_workouts(end_date)
                 |> Enum.to_list()
      end
    end
  end

  describe "OAuth2 and client delegates" do
    test "delegates OAuth2 helper functions" do
      tokens = %{expires_at: DateTime.add(DateTime.utc_now(), 3600)}

      with_mock ExOura.OAuth2, [:passthrough],
        authorization_url: fn [state: "state-123"] -> "https://example.com/auth" end,
        get_token: fn "code-123", [redirect_uri: "http://localhost/callback"] -> {:ok, %{access_token: "token"}} end,
        refresh_token: fn "refresh-123", [scope: "daily"] -> {:ok, %{access_token: "new-token"}} end,
        token_expired?: fn ^tokens, 600 -> false end,
        available_scopes: fn -> ["daily", "personal"] end,
        default_scopes: fn -> ["personal", "daily"] end do
        assert "https://example.com/auth" = ExOura.authorization_url(state: "state-123")

        assert {:ok, %{access_token: "token"}} =
                 ExOura.get_token("code-123", redirect_uri: "http://localhost/callback")

        assert {:ok, %{access_token: "new-token"}} =
                 ExOura.refresh_token("refresh-123", scope: "daily")

        assert ExOura.token_expired?(tokens, 600) == false
        assert ExOura.available_scopes() == ["daily", "personal"]
        assert ExOura.default_scopes() == ["personal", "daily"]
      end
    end

    test "delegates set_auth_config to the client" do
      auth_config = [client_id: "client-id", client_secret: "client-secret", redirect_uri: "http://localhost/callback"]

      with_mock ExOura.Client, [:passthrough], set_auth_config: fn ^auth_config -> :ok end do
        assert :ok = ExOura.set_auth_config(auth_config)
      end
    end
  end
end
