# ExOura

[![Coverage Status](https://coveralls.io/repos/github/tgrk/ex_oura/badge.svg)](https://coveralls.io/github/tgrk/ex_oura)

An Elixir library for [Oura API](https://cloud.ouraring.com/v2/docs) with a base client generated using [OpenAPI Code Generator](https://github.com/aj-foster/open-api-generator) from [OpenApi specs v1.23](https://cloud.ouraring.com/v2/static/json/openapi-1.23.json).

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

TBD

## TODO
- Docs
  - Add description
  - Add basic howto
- Hex
  - Add Hex package informaton
  - Generate docs (use exdocs, maybe OpenApi, configure hex)
- Github
  - Add release please (for changelog)

- Improve type handling

  ## Oura OpenApi issues

  - no title for tag/timestamp
  - daily cardiovascular age has no ID -> no way to query a single document 