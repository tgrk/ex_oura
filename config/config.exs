import Config

config :ex_oura,
  timeout: 10_000

config :exvcr,
  vcr_cassette_library_dir: "test/fixture/vcr_cassettes",
  filter_request_headers: ["authorization"]

# Ony used for generating client from OpenAPI spec
config :oapi_generator,
  default: [
    output: [
      base_module: ExOura,
      location: "lib/client"
    ]
  ]
