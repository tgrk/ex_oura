defmodule ExOura.TypeDecoderTest do
  use ExUnit.Case, async: true

  alias ExOura.Client.MultiDocumentResponseDict
  alias ExOura.Client.MultiDocumentResponsePublicWorkout
  alias ExOura.Client.PublicWorkout
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
end
