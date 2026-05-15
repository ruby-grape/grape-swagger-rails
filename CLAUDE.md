# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Gem Does

**grape-swagger-rails** is a Rails Engine gem that mounts a Swagger UI interface for APIs documented with the `grape-swagger` gem. It provides a single mountable engine that renders Swagger UI v5 with configurable authentication, theming, and authorization hooks.

## Commands

```bash
bundle exec rake            # Run full suite: RuboCop + RSpec (default)
bundle exec rake spec       # Run all RSpec tests only
bundle exec rake rubocop    # Run RuboCop linting only
bundle exec rspec spec/features/swagger_spec.rb  # Run a single spec file

yarn build:frontend         # tsc → index.js, then esbuild → index.min.js (+ .map)
yarn build:frontend:js      # Just tsc (readable bundle)
yarn build:frontend:min     # Just esbuild (minified bundle, consumes index.js)
yarn typecheck              # Type-check TypeScript without emitting

bundle exec rake swagger_ui:dist:update          # Update bundled Swagger UI assets
SWAGGER_UI_VERSION=v5.32.5 bundle exec rake swagger_ui:dist:update  # Pin to a version
```

Tests use Capybara + Selenium with Firefox. Firefox and geckodriver must be installed locally. On macOS, `xvfb` is not needed (unlike CI). Tests launch a real browser to validate UI behavior.

**After editing TypeScript**, run `yarn build:frontend` before running specs — the specs exercise `app/assets/javascripts/grape_swagger_rails/index.js`, which is the compiled output. Never edit the compiled JS directly. The build also emits `index.min.js` (+ sourcemap); the view picks the minified bundle in production (`Rails.env.production?`) via `grape_swagger_rails_runtime_asset` and the readable one everywhere else.

## Architecture

The gem has minimal moving parts:

- **`lib/grape-swagger-rails.rb`** — Defines `GrapeSwaggerRails.options` as an OpenStruct. All configuration lives here (URL, auth type, headers, theme, before_action proc, etc.).
- **`lib/grape-swagger-rails/engine.rb`** — Rails Engine. Configures asset precompilation for both Sprockets and Propshaft pipelines.
- **`app/controllers/grape_swagger_rails/application_controller.rb`** — Single `index` action. Runs `options.before_action_proc` in controller context for authorization.
- **`app/views/grape_swagger_rails/application/index.html.haml`** — The entire UI. Serializes `GrapeSwaggerRails.options` as JSON into `data-swagger-options`, then JavaScript parses it to initialize SwaggerUIBundle. Handles theme toggling and auth injection via Swagger UI's `requestInterceptor`.
- **`frontend/grape_swagger_rails/index.ts`** — TypeScript source for the browser runtime. `tsc` compiles it to `app/assets/javascripts/grape_swagger_rails/index.js` (readable, ES5); `esbuild` then minifies that into `index.min.js` (+ `.map`). Both files are checked in so they ship with the gem. The TypeScript interface `SwaggerPageOptions` is the authoritative schema for options consumed by JS.
- **`config/routes.rb`** — Single root route → `ApplicationController#index`.
- **`lib/tasks/swagger_ui.rake`** — Rake task that clones `swagger-api/swagger-ui` and copies dist files into `app/assets/`.

### Key Patterns

**Configuration flow:** Host app sets options in an initializer → options serialized to JSON in the view → JavaScript reads them at page load.

**Auth injection:** All authentication (basic, bearer, token, API key) is implemented client-side via Swagger UI's `requestInterceptor`, not Rails middleware. The interceptor appends headers or query params to every outbound API request.

**Before-action authorization:** `GrapeSwaggerRails.options.before_action { redirect_to '/' unless current_user }` — the proc runs in the controller's binding, so it has full access to helpers, `current_user`, etc.

**Multiple spec URLs:** Set `options.urls` (array) instead of `options.url` to expose a spec selector dropdown. Each entry can be a string URL or `{ name:, url: }` hash. `options.urls_primary_name` selects the default.

**Swagger UI pass-through:** `options.swagger_ui_config` is merged into the `SwaggerUIBundle(...)` call before gem defaults, allowing any native Swagger UI option to be set. Gem-owned keys (`url`, `requestInterceptor`, `presets`) still take precedence.

**Asset pipeline:** The engine conditionally handles both Sprockets (`config.assets.precompile`) and Propshaft. If modifying assets, verify both pipelines work — CI tests both.

## Testing Structure

```
spec/
  features/
    swagger_spec.rb              # Main integration tests (auth types, theme, headers)
    grape-swagger-rails_spec.rb  # Core functionality and options
    welcome_spec.rb              # Basic rendering
  dummy/                         # Minimal Rails app used by all tests
    app/api/                     # Sample Grape API with swagger docs
```

The dummy app in `spec/dummy/` is the test harness. Integration tests drive a real browser against it.

## RuboCop

Config in `.rubocop.yml` targets Ruby 3.4. Plugins: rubocop-capybara, rubocop-rspec. Overrides tracked in `.rubocop_todo.yml`.

## Compatibility Matrix

- Rails 7.2 / 8.1 × Ruby 3.2–3.4 × grape-swagger 2.1.4 (grape ~> 3.1)
- Rails 7.2 × Ruby 3.2 × grape-swagger 1.6.1 (grape ~> 1.8) — legacy combination
- Ruby 3.1 is excluded from Rails 8 (requires 3.2+)
- grape ~> 1.8 is not tested on Ruby 3.4: Ruby 3.4 tightened `Forwardable` to raise on private-method delegation, which breaks Mustermann's `named_captures` forwarding used by grape-swagger 1.6.1 to introspect routes
- Both Sprockets and Propshaft asset pipelines are tested in CI
