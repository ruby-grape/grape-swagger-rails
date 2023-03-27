lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape-swagger-rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape-swagger-rails'
  spec.version       = GrapeSwaggerRails::VERSION
  spec.authors       = ['Alexander Logunov']
  spec.email         = ['unlovedru@gmail.com']
  spec.description   = 'Swagger UI as Rails Engine for grape-swagger gem'
  spec.summary       = 'Swagger UI as Rails Engine for grape-swagger gem'
  spec.homepage      = 'https://github.com/ruby-grape/grape-swagger-rails'
  spec.license       = 'MIT'
  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.test_files    = `git ls-files spec`.split($INPUT_RECORD_SEPARATOR)
  spec.require_paths = %w[lib]

  spec.add_dependency 'railties', '>= 6.0.6.1'
end
