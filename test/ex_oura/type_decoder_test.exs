defmodule ExOura.TypeDecoderTest do
  use ExUnit.Case, async: true

  alias ExOura.Client.EnhancedTagModel
  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponsePublicWorkout
  alias ExOura.Client.PublicModifiedSleepModel
  alias ExOura.Client.PublicRingConfiguration
  alias ExOura.Client.PublicWorkout
  alias ExOura.Client.TagModel
  alias ExOura.Client.ValidationError
  alias ExOura.Client.WebhookSubscriptionModel
  alias ExOura.TypeDecoder

  test "preserves scalar validation error input" do
    operation = %{response: %{422 => {ValidationError, :t}}}
    body = %{input: "invalid-date", loc: ["query", "start_date"], msg: "Invalid date", type: "date_parsing"}

    assert {:ok, %ValidationError{input: "invalid-date"}} = TypeDecoder.decode_response(422, body, operation)
  end

  test "preserves dict union responses when nested rows contain extra fields" do
    operation = %{
      query: [fields: "extra_metric"],
      response: %{
        200 =>
          {:union,
           [
             {MultiDocumentResponseDict, :t},
             {MultiDocumentResponsePublicWorkout, :t}
           ]}
      }
    }

    body = %{
      data: [
        %{
          id: "workout-id-123",
          label: "Morning run",
          extra_metric: 123
        }
      ],
      next_token: nil
    }

    assert {:ok,
            %MultiDocumentResponseDict{
              data: [
                %{
                  id: "workout-id-123",
                  label: "Morning run",
                  extra_metric: 123
                }
              ],
              next_token: nil
            }} = TypeDecoder.decode_response(200, body, operation)
  end

  test "does not prefer dict unions when fields is empty" do
    operation = %{
      query: [fields: []],
      response: %{
        200 =>
          {:union,
           [
             {MultiDocumentResponseDict, :t},
             {MultiDocumentResponsePublicWorkout, :t}
           ]}
      }
    }

    body = %{
      data: [
        %{
          activity: "running",
          calories: 300.5,
          day: "2024-01-15",
          distance: 5000,
          end_datetime: "2024-01-15T08:30:00Z",
          id: "workout-id-123",
          intensity: "moderate",
          label: "Morning run",
          source: "manual",
          start_datetime: "2024-01-15T08:00:00Z"
        }
      ],
      next_token: nil
    }

    assert {:ok,
            %MultiDocumentResponsePublicWorkout{
              data: [
                %PublicWorkout{
                  activity: "running",
                  day: ~D[2024-01-15],
                  end_datetime: ~U[2024-01-15 08:30:00Z],
                  start_datetime: ~U[2024-01-15 08:00:00Z]
                }
              ],
              next_token: nil
            }} = TypeDecoder.decode_response(200, body, operation)
  end

  test "keeps ordinary string fields as strings while parsing date-like field names" do
    operation = %{response: %{200 => {PublicWorkout, :t}}}

    body = %{
      activity: "running",
      calories: 300.5,
      day: "2024-01-15",
      distance: 5000,
      end_datetime: "2024-01-15T08:30:00Z",
      id: "workout-id-123",
      intensity: "moderate",
      label: "2024-01-15",
      source: "manual",
      start_datetime: "2024-01-15T08:00:00Z"
    }

    assert {:ok,
            %PublicWorkout{
              day: ~D[2024-01-15],
              end_datetime: ~U[2024-01-15 08:30:00Z],
              label: "2024-01-15",
              start_datetime: ~U[2024-01-15 08:00:00Z]
            }} = TypeDecoder.decode_response(200, body, operation)
  end

  test "decodes current ring configuration values and setup time" do
    operation = %{response: %{200 => {PublicRingConfiguration, :t}}}

    body = %{
      color: "deep_rose",
      firmware_version: "1.2.3",
      hardware_type: "or5",
      id: "ring-config-123",
      set_up_at: "2024-01-01T09:00:00Z",
      size: 10
    }

    assert {:ok,
            %PublicRingConfiguration{
              color: "deep_rose",
              firmware_version: "1.2.3",
              hardware_type: "or5",
              set_up_at: ~U[2024-01-01 09:00:00Z]
            }} = TypeDecoder.decode_response(200, body, operation)
  end

  test "decodes workouts recorded with live heart rate sources" do
    operation = %{response: %{200 => {PublicWorkout, :t}}}

    for source <- ["live_third_party_heart_rate", "live_oura_heart_rate"] do
      body = %{
        activity: "running",
        calories: 300.5,
        day: "2024-01-15",
        distance: 5000,
        end_datetime: "2024-01-15T08:30:00Z",
        id: "workout-id-123",
        intensity: "moderate",
        label: nil,
        source: source,
        start_datetime: "2024-01-15T08:00:00Z"
      }

      assert {:ok,
              %PublicWorkout{
                day: ~D[2024-01-15],
                end_datetime: ~U[2024-01-15 08:30:00Z],
                source: ^source,
                start_datetime: ~U[2024-01-15 08:00:00Z]
              }} = TypeDecoder.decode_response(200, body, operation)
    end
  end

  test "decodes sleep responses with the retired ring ID set to null" do
    operation = %{response: %{200 => {PublicModifiedSleepModel, :t}}}

    body = %{
      app_sleep_phase_5_min: nil,
      average_breath: nil,
      average_heart_rate: nil,
      average_hrv: nil,
      awake_time: nil,
      bedtime_end: "2024-01-15T08:00:00Z",
      bedtime_start: "2024-01-15T00:00:00Z",
      day: "2024-01-15",
      deep_sleep_duration: nil,
      efficiency: nil,
      heart_rate: nil,
      hrv: nil,
      id: "sleep-id-123",
      latency: nil,
      light_sleep_duration: nil,
      low_battery_alert: false,
      lowest_heart_rate: nil,
      movement_30_sec: nil,
      period: 0,
      readiness: nil,
      readiness_score_delta: nil,
      rem_sleep_duration: nil,
      restless_periods: nil,
      ring_id: nil,
      sleep_algorithm_version: nil,
      sleep_analysis_reason: nil,
      sleep_phase_30_sec: nil,
      sleep_phase_5_min: nil,
      sleep_score_delta: nil,
      time_in_bed: 28_800,
      total_sleep_duration: nil,
      type: "long_sleep"
    }

    assert {:ok,
            %PublicModifiedSleepModel{
              bedtime_end: ~U[2024-01-15 08:00:00Z],
              bedtime_start: ~U[2024-01-15 00:00:00Z],
              day: ~D[2024-01-15],
              ring_id: nil,
              time_in_bed: 28_800
            }} = TypeDecoder.decode_response(200, body, operation)
  end

  test "decodes explicit date and datetime schema formats" do
    enhanced_tag_operation = %{response: %{200 => {EnhancedTagModel, :t}}}
    webhook_operation = %{response: %{200 => {WebhookSubscriptionModel, :t}}}

    enhanced_tag_body = %{
      comment: nil,
      custom_name: "Wind down",
      end_day: "2024-01-16",
      end_time: "21:15:00",
      id: "tag-123",
      start_day: "2024-01-15",
      start_time: "20:00:00",
      tag_type_code: "rest"
    }

    webhook_body = %{
      callback_url: "https://example.com/webhook",
      data_type: "workout",
      event_type: "create",
      expiration_time: "2024-01-31T09:45:00Z",
      id: "subscription-123"
    }

    assert {:ok,
            %EnhancedTagModel{
              end_day: ~D[2024-01-16],
              end_time: "21:15:00",
              start_day: ~D[2024-01-15],
              start_time: "20:00:00"
            }} = TypeDecoder.decode_response(200, enhanced_tag_body, enhanced_tag_operation)

    assert {:ok,
            %WebhookSubscriptionModel{
              expiration_time: ~U[2024-01-31 09:45:00Z]
            }} = TypeDecoder.decode_response(200, webhook_body, webhook_operation)
  end

  test "decodes list response declarations into typed rows" do
    operation = %{response: %{200 => [{TagModel, :t}]}}

    body = [
      %{
        day: "2024-01-15",
        id: "tag-1",
        tags: ["rest"],
        text: "Felt good",
        timestamp: "2024-01-15T08:30:00Z"
      }
    ]

    assert {:ok,
            [
              %TagModel{
                day: ~D[2024-01-15],
                id: "tag-1",
                tags: ["rest"],
                text: "Felt good",
                timestamp: ~U[2024-01-15 08:30:00Z]
              }
            ]} = TypeDecoder.decode_response(200, body, operation)
  end
end
