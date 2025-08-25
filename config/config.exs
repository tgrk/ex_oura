import Config

config :ex_oura,
  timeout: 10_000,
  # Rate limiting configuration
  rate_limiting: [
    enabled: true,
    daily_limit: 5000,
    per_minute_limit: 300
  ],
  # Retry configuration (uses Req's built-in retry mechanism)
  retry: [
    max_retries: 3
  ]

# used for testing
config :exvcr,
  vcr_cassette_library_dir: "test/fixture/vcr_cassettes",
  filter_request_headers: ["authorization", "x-client-id", "x-client-secret"]

# used for generating client from OpenAPI spec
config :oapi_generator,
  default: [
    output: [
      base_module: ExOura,
      location: "lib/ex_oura/client"
    ]
  ]
