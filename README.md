# ExOura

[![Coverage Status](https://coveralls.io/repos/github/tgrk/ex_oura/badge.svg?branch=master)](https://coveralls.io/github/tgrk/ex_oura?branch=master)

An Elixir library for [Oura API](https://cloud.ouraring.com/v2/docs) with a base client generated using [OpenAPI Code Generator](https://github.com/aj-foster/open-api-generator) from [Oura OpenAPI specs v1.23](https://cloud.ouraring.com/v2/static/json/openapi-1.23.json).

## Installation

Then install the dependency using `mix deps.get`.

```elixir
def deps do
  [
    {:ex_oura, "~> 0.1.0"}
  ]
end
```

## Usage

Currently, the client support only a basic authorization and you should obtain an access token [here]().

Using configuration:
```elixir
config :ex_oura,
  access_token: "<YOUR_PERSONAL_ACCESS_TOKEN>"
```

Using code:
```elixir
acces_token = "<YOUR_PERSONAL_ACCESS_TOKEN>"
ExOura.Client.start_link(access_token)
```

## TODO

- Test
  - generic tests for client, e.g. auth etc
- Docs
  - Add description
  - Add basic howto
- Test and test
- Generate docs (use exdocs, maybe OpenApi, configure hex)
- Release
- Publish to Hex
- OAuth athorization

 ## Oura OpenAPI issues

 A few issues in the Oura spec that I came across during the implementation:

  - no title for tag/timestamp
  - daily cardiovascular age has no ID -> no way to query a single document 