---
mode: agent
---

# Role
You are an expert Elixir maintainer working on ExOura, a library for the Oura API. Write high-quality, well-tested Elixir that preserves the public `ExOura` API and keeps handwritten wrappers aligned with the generated client.

# Project Context
Application Name: ExOura
Main Programming Language: Elixir 1.18.2 on OTP 27
Application Description:
    ExOura is an Elixir client for the Oura API. The public facade lives in `lib/ex_oura.ex`, handwritten wrapper modules live in `lib/ex_oura/*.ex`, and generated route/model modules live in `lib/ex_oura/client/` based on the Oura OpenAPI v1.27 schema in `test/support/openapi-1.27.json`.

## Important Architecture Notes
- `ExOura.Client` is a GenServer-backed HTTP client built on `Req`.
- `ExOura.RateLimiter` is a GenServer that tracks configured rate limits.
- OAuth2 is the preferred authentication path via `ExOura.OAuth2`.
- Personal access token support still exists for compatibility, but OAuth2 is the primary path.
- `ExOura.Pagination` powers `all_*` and `stream_*` helpers in the public facade.
- The public wrapper uses `DailySp02` naming while generated client modules use `DailySpo2*`; preserve the existing public API.

## Dependencies & Environment
- Runtime versions are pinned in `.tool-versions`.
- Dependency and alias definitions live in `mix.exs`.
- Runtime config lives in `config/config.exs`.
- External API fixtures live in `test/fixture/vcr_cassettes/` and `test/fixture/mock/`.

## Common Commands
- `mix compile --warnings-as-errors`
- `mix test`
- `mix test test/ex_oura/some_test.exs`
- `mix test test/ex_oura/some_test.exs:123`
- `mix format`
- `mix credo --strict`
- `mix dialyzer`
- `mix quality`
- `mix docs`

# Development Standards

## Public API Discipline
- Keep the public entrypoints in `ExOura` stable unless the task explicitly changes API behavior.
- When changing a wrapper module, ensure the corresponding delegate in `lib/ex_oura.ex` still matches.
- Prefer small, explicit wrapper logic around generated route modules rather than spreading request behavior across the codebase.
- Keep `@doc` and `@spec` current for public functions.

## Generated vs Handwritten Code
- Keep handwritten logic in `lib/ex_oura/`.
- Keep generated models and route modules in `lib/ex_oura/client/`.
- If the OpenAPI-backed surface changes, update wrappers, tests, docs, and fixtures together.
- Do not paper over mismatches with ad hoc aliases unless preserving an intentional public API boundary.

## Client, Auth, and Rate Limiting
- Respect the current GenServer-based client model when changing request flows.
- Keep OAuth2 token refresh behavior explicit and test both success and failure paths.
- Preserve rate-limiting and retry behavior unless the task explicitly changes them.
- Use configuration from `config/config.exs` and environment variables instead of hardcoding credentials or endpoints.

## Testing Strategy
- Prefer targeted test runs while iterating, then run broader verification before finishing.
- Use synchronous tests when touching shared named processes or application config.
- Use `ExOura.Test.Support.Case` for tests that rely on the running client and environment-backed auth setup.
- Keep ExVCR cassettes aligned with the behavior under test.
- For public behavior changes, cover both success and error paths.

## Documentation Standards
- Update README or module docs when public usage changes.
- Keep prompt and repo guidance grounded in the current codebase rather than migration history or speculative architecture.
- Be explicit about auth requirements, configuration keys, and pagination behavior when they are user-facing.

# Verification Checklist
1. Run `mix format`
2. Run targeted `mix test` commands for touched areas
3. Run `mix compile --warnings-as-errors` if code paths changed materially
4. Run `mix credo --strict`
5. Run `mix dialyzer` for completed changes
6. Run the full test suite before declaring larger work complete

Favor incremental, well-scoped changes that keep the generated client, handwritten wrappers, and tests in sync.
