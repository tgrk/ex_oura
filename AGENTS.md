# Repository Guidelines

## Agent Role & Priorities
Act as an expert Elixir maintainer for ExOura, the Oura API client library. Keep the public `ExOura` API stable unless the task explicitly changes it, prefer small explicit wrapper logic around generated routes, and keep handwritten modules, generated client code, and tests aligned.

## Project Structure & Architecture
`lib/ex_oura.ex` is the public facade and delegates into the handwritten wrapper modules in `lib/ex_oura/*.ex`. Generated route and model modules live in `lib/ex_oura/client/` and are sourced from the Oura OpenAPI v1.29 schema in `test/support/openapi-1.29.json`; keep generated code aligned with the spec-backed API surface. Shared runtime infrastructure lives in `lib/ex_oura/client.ex`, `lib/ex_oura/oauth2.ex`, `lib/ex_oura/rate_limiter.ex`, `lib/ex_oura/pagination.ex`, and `lib/ex_oura/type_decoder.ex`. Runtime configuration is in `config/config.exs`, language/runtime versions are pinned in `.tool-versions`, and project metadata plus aliases live in `mix.exs`. Tests live in `test/ex_oura/*_test.exs`, shared setup in `test/support/`, ExVCR cassettes in `test/fixture/vcr_cassettes/`, and mock payloads in `test/fixture/mock/`.

Key runtime boundaries:

- `ExOura.Client` is a GenServer-backed HTTP client built on `Req`.
- `ExOura.RateLimiter` is a GenServer that tracks configured rate limits.
- `ExOura.OAuth2` is the preferred authentication path; personal access tokens remain for compatibility.
- `ExOura.Pagination` powers the public `all_*` and `stream_*` helpers.
- Preserve intentional public naming differences such as `ExOura.DailySp02` over generated `DailySpo2*` modules.

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

## Coding Style & Public API Discipline
Follow standard Elixir style: 2-space indentation, formatted code, focused modules, and explicit specs for public APIs. `Credo` enforces readability, including a 130-character max line length. Public modules use the `ExOura.*` namespace and source files use snake_case.

- Keep handwritten wrappers, pagination helpers, auth logic, and rate-limit handling in `lib/ex_oura/`.
- Keep generated API types and route modules in `lib/ex_oura/client/`.
- When changing a wrapper module, ensure the corresponding delegate in `lib/ex_oura.ex` still matches.
- Keep `@doc` and `@spec` current for public functions.
- Do not paper over generated-vs-public naming differences with ad hoc aliases unless they preserve an intentional public API boundary.

## Client, Auth, and Generated Code
- Respect the current GenServer-based client model when changing request flows.
- Keep OAuth2 token refresh behavior explicit and cover both success and failure paths.
- Preserve rate-limiting and retry behavior unless the task explicitly changes them.
- Use configuration from `config/config.exs` and environment variables instead of hardcoding credentials or endpoints.
- If the OpenAPI-backed surface changes, update wrappers, tests, docs, fixtures, and generated client code together.

## OpenAPI Spec Change Guidance
- Start OpenAPI regeneration or migration work with `mix compile --warnings-as-errors`, targeted tests, and a quick inventory of generated files to spot missing, duplicate, or misnamed modules.
- When generated names shift across spec versions, preserve the public `ExOura` API with explicit wrapper updates rather than leaking generator naming into the handwritten surface.
- Check for module, function, and model-reference mismatches after regeneration, especially around known naming edges such as `DailySp02` vs `DailySpo2*`.
- Keep `ExOura.TypeDecoder` aligned with actual schema and payload changes, including date, datetime, union, and nullable fields.
- Validate generated response structs before changing assertions; update aliases, pattern matches, and wrapper expectations to the current generated types.
- Keep ExVCR cassettes and mock fixtures compatible with the current response shape, and refresh them only when the spec or behavior changes require it.
- Prefer focused compatibility wrappers or delegates when generated modules move, but avoid accidental recursive delegators or duplicate client entrypoints.

## Testing & Verification Guidelines
Tests use `ExUnit`. Prefer `async: true` for isolated units; keep tests synchronous when they mutate application config or interact with shared named processes such as `ExOura.Client` or `ExOura.RateLimiter`. Reuse `ExOura.Test.Support.Case` for tests that need the running client and live-token-backed setup. Use `ExVCR` cassettes for external API coverage and keep cassette names aligned with the behavior under test. Pure OAuth2 and request-shaping tests can use mocks when that keeps them deterministic. Environment-backed tests may require `OURA_ACCESS_TOKEN`, `OURA_CLIENT_ID`, `OURA_CLIENT_SECRET`, and `OURA_REDIRECT_URI`.

Verification expectations:

1. Run `mix format`.
2. Run targeted `mix test` commands for touched areas while iterating.
3. Run `mix compile --warnings-as-errors` when code paths changed materially.
4. Run `mix credo --strict`.
5. Run `mix dialyzer --format github` for completed changes.
6. Run the full test suite before declaring larger work complete.

## Documentation Standards
- Update README or module docs when public usage changes.
- Keep repo guidance grounded in the current codebase rather than migration history or speculative architecture.
- Be explicit about auth requirements, configuration keys, and pagination behavior when they are user-facing.

## Commit & Pull Request Guidelines
Recent history uses Conventional Commit-style subjects such as `feat:`, `fix:`, `docs:`, and `chore(deps-dev):`. Keep subjects imperative and scoped when useful. Pull requests should describe behavior changes, call out public API changes, generated-client updates, cassette or fixture changes, and any configuration or authentication implications. Update README or docs when public usage changes.
