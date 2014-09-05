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
  spec.test_files    = `git ls-files spec`.split($/)
  spec.require_paths = %w(lib)

  spec.add_dependency 'railties', '>= 3.2.12'
  spec.add_dependency 'grape-swagger', '~> 0.7.2'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'git'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'grape'
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency 'sass-rails'
  spec.add_development_dependency 'uglifier'
  spec.add_development_dependency 'coffee-rails'
  spec.add_development_dependency 'jquery-rails'
  spec.add_development_dependency 'grape-swagger-ui'
  spec.add_development_dependency 'sprockets'
  spec.add_development_dependency 'rack-cors'
end
