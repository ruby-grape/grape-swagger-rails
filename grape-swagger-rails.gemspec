# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape-swagger-rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape-swagger-rails'
  spec.version       = GrapeSwaggerRails::VERSION
  spec.authors       = ['Aleksandr B. Ivanov', 'Alexander Logunov']
  spec.email         = ['radanisk@ya.ru', 'unlovedru@gmail.com']
  spec.description   = %q{grape grape-swagger swagger-ui rails integration}
  spec.summary       = %q{grape grape-swagger swagger-ui rails integration}
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.files         = `git ls-files`.split($/)
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_dependency 'railties', '~> 3.2.12'
  spec.add_dependency 'rubyzip', '~> 0.9.9'
  spec.add_dependency 'grape-swagger', '~> 0.5.0'
end
