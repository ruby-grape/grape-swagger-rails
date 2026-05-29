# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

grape-swagger is a Ruby gem that auto-generates Swagger 2.0 documentation for Grape APIs. It extends Grape APIs with `add_swagger_documentation` to register documentation endpoints that output OpenAPI/Swagger-compliant JSON.

**Key dependencies:** Grape >= 1.7 (supports up to 3.x), Ruby >= 3.1

## Common Commands

```bash
# Install dependencies
bundle install

# Run all tests + RuboCop
bundle exec rake

# Run tests only
bundle exec rspec

# Run a single test file
bundle exec rspec spec/swagger_v2/api_swagger_v2_spec.rb

# Run a specific test by line number
bundle exec rspec spec/swagger_v2/api_swagger_v2_spec.rb:42

# Run RuboCop linting
bundle exec rubocop

# Test with different model parsers
MODEL_PARSER=grape-swagger-entity bundle exec rspec
MODEL_PARSER=grape-swagger-representable bundle exec rspec

# Test with a specific Grape version
GRAPE_VERSION=2.2.0 bundle update && bundle exec rspec
```

## Architecture

### Core Extension Flow

1. **Entry point:** `lib/grape-swagger.rb` - Extends `GrapeInstance` with `SwaggerDocumentationAdder` mixin
2. **Endpoint generation:** `lib/grape-swagger/endpoint.rb` - Extends `Grape::Endpoint` to build Swagger objects from route definitions
3. **Documentation helpers:** `lib/grape-swagger/doc_methods.rb` - Central module for generating paths, definitions, tags

### Pluggable Systems

**Model Parsers** (`lib/grape-swagger/model_parsers.rb`):
- Registry for handling different entity types (Grape::Entity, representable, custom)
- Access via `GrapeSwagger.model_parsers`
- Supports `insert_before` and `insert_after` for ordering

**Request Param Parsers** (`lib/grape-swagger/request_param_parser_registry.rb`):
- Three default parsers: Headers, Route, Body (in `request_param_parsers/`)
- Access via `GrapeSwagger.request_param_parsers`

### Key Modules

- `SwaggerDocumentationAdder` - Adds `add_swagger_documentation` method to Grape APIs
- `SwaggerRouting` - Combines routes by resource path, handles namespace routing
- `GrapeSwagger::DocMethods` - Helpers in `doc_methods/` subdirectory for specific documentation tasks

## Testing Patterns

- Tests use `Rack::Test::Methods` for HTTP testing
- Define an `app` method returning a `Grape::API` subclass in specs
- Use shared contexts like `include_context "#{MODEL_PARSER} swagger example"` for model parser testing
- Tests run with random order (seed: 40834)
- `MODEL_PARSER` env var controls which parser to test (mock, entity, representable)

## Code Style

- Always include `# frozen_string_literal: true` at file start
- Max line length: 120 characters
- RuboCop enforced with some rules relaxed in `.rubocop_todo.yml`
- Naming cops disabled; Style cops mostly disabled
- Spec files excluded from most length/complexity checks

## Contributing Workflow

1. Create feature branch from master
2. Write tests first (add to `spec/`)
3. Implement feature
4. Run `bundle exec rake` (must pass)
5. Add entry to CHANGELOG.md under *Next Release*
6. Submit PR
