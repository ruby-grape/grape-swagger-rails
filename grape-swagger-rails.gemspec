# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape-swagger-rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape-swagger-rails'
  spec.version       = GrapeSwaggerRails::VERSION
  spec.authors       = ['Alexander Logunov']
  spec.email         = ['unlovedru@gmail.com']
  spec.description   = 'Swagger UI as Rails Engine for grape-swagger gem.'
  spec.summary       = 'Swagger UI as Rails Engine for grape-swagger gem.'
  spec.homepage      = 'https://github.com/ruby-grape/grape-swagger-rails'
  spec.license       = 'MIT'
  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.require_paths = %w[lib]
  spec.add_dependency 'railties', '>= 6.0.6.1'
  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/ruby-grape/grape-swagger-rails/issues',
    'changelog_uri' => 'https://github.com/ruby-grape/grape-swagger-rails/blob/master/CHANGELOG.md',
    'source_code_uri' => "https://github.com/ruby-grape/grape-swagger-rails/tree/v#{GrapeSwaggerRails::VERSION}",
    'rubygems_mfa_required' => 'true'
  }
end
