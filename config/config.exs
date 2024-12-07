import Config

# Ony used for generating client from OpenAPI spec
config :oapi_generator,
  default: [
    output: [
      base_module: ExOura,
      location: "lib/client"
    ]
  ]
