# Repository Guidelines

## Project Structure & Module Organization
`lib/ex_oura.ex` is the public facade and delegates into the handwritten wrapper modules in `lib/ex_oura/*.ex`. Generated route and model modules live in `lib/ex_oura/client/` and are sourced from the Oura OpenAPI v1.29 schema; keep generated code aligned with the spec-backed API surface. Shared runtime infrastructure lives in `lib/ex_oura/client.ex`, `lib/ex_oura/oauth2.ex`, `lib/ex_oura/rate_limiter.ex`, `lib/ex_oura/pagination.ex`, and `lib/ex_oura/type_decoder.ex`. Runtime configuration is in `config/config.exs`, language/runtime versions are pinned in `.tool-versions`, and project metadata plus aliases live in `mix.exs`. Tests live in `test/ex_oura/*_test.exs`, shared setup in `test/support/`, ExVCR cassettes in `test/fixture/vcr_cassettes/`, mock payloads in `test/fixture/mock/`, and the checked-in OpenAPI schema in `test/support/openapi-1.29.json`.

## Build, Test, and Development Commands
Use Mix for normal development:

- `mix deps.get` installs dependencies.
- `mix compile --warnings-as-errors` matches the main CI compile gate.
- `mix test` runs the full test suite.
- `mix test test/ex_oura/some_test.exs` or `mix test test/ex_oura/some_test.exs:123` runs targeted tests.
- `mix coverage` or `MIX_ENV=test mix coveralls` runs coverage locally; CI uses `mix coveralls.github`.
- `mix format` formats code with `Styler`; `mix format --check-formatted` verifies formatting.
- `mix credo --strict` runs the lint rules used by the repo.
- `mix dialyzer --format github` runs static analysis; `mix quality` runs format, Credo, and Dialyzer.
- `mix docs` rebuilds HexDocs output.

## Coding Style & Naming Conventions
Follow standard Elixir style: 2-space indentation, formatted code, focused modules, and explicit specs for public APIs. `Credo` enforces readability, including a 130-character max line length. Public modules use the `ExOura.*` namespace and source files use snake_case. Keep handwritten wrappers, pagination helpers, auth logic, and rate-limit handling in `lib/ex_oura/`; keep generated API types and route modules in `lib/ex_oura/client/`. Preserve the existing public naming even where generated modules differ, for example the public wrapper `ExOura.DailySp02` sits on top of generated `DailySpo2*` modules.

## Testing Guidelines
Tests use `ExUnit`. Prefer `async: true` for isolated units; keep tests synchronous when they mutate application config or interact with shared named processes such as `ExOura.Client` or `ExOura.RateLimiter`. Reuse `ExOura.Test.Support.Case` for tests that need the running client and live-token-backed setup. Use `ExVCR` cassettes for external API coverage and keep cassette names aligned with the behavior under test. Pure OAuth2 and request-shaping tests can use mocks when that keeps them deterministic. Environment-backed tests may require `OURA_ACCESS_TOKEN`, `OURA_CLIENT_ID`, `OURA_CLIENT_SECRET`, and `OURA_REDIRECT_URI`.

## Commit & Pull Request Guidelines
Recent history uses Conventional Commit-style subjects such as `feat:`, `fix:`, `docs:`, and `chore(deps-dev):`. Keep subjects imperative and scoped when useful. Pull requests should describe behavior changes, call out public API changes, generated-client updates, cassette or fixture changes, and any configuration or authentication implications. Update README or docs when public usage changes.
