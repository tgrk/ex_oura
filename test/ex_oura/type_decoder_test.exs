defmodule ExOura.TypeDecoderTest do
  use ExUnit.Case, async: true

  alias ExOura.Client.EnhancedTagModel
  alias ExOura.Client.Metadata
  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponsePublicWorkout
  alias ExOura.Client.PublicRingConfiguration
  alias ExOura.Client.PublicWorkout
  alias ExOura.Client.TagModel
  alias ExOura.Client.WebhookSubscriptionModel
  alias ExOura.TypeDecoder

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
          meta: nil,
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
      meta: nil,
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

  test "parses nested temporal metadata fields without coercing ordinary strings" do
    operation = %{response: %{200 => {PublicRingConfiguration, :t}}}

    body = %{
      color: "tide",
      firmware_version: "1.2.3",
      hardware_type: "gen4",
      id: "ring-config-123",
      meta: %{
        updated_at: "2024-01-15T08:30:00Z",
        version: 7
      },
      set_up_at: "2024-01-01T09:00:00Z",
      size: 10
    }

    assert {:ok,
            %PublicRingConfiguration{
              firmware_version: "1.2.3",
              meta: %Metadata{
                updated_at: ~U[2024-01-15 08:30:00Z],
                version: 7
              },
              set_up_at: ~U[2024-01-01 09:00:00Z]
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
