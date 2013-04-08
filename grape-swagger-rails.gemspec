# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape/swagger/rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape-swagger-rails'
  spec.version       = Grape::Swagger::Rails::VERSION
  spec.authors       = ['Aleksandr B. Ivanov']
  spec.email         = %w(radanisk@ya.ru)
  spec.description   = %q{grape-swagger rails integration}
  spec.summary       = %q{grape-swagger rails integration}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_dependency 'railties', '~> 3.2.13'
  spec.add_dependency 'rubyzip', '~> 0.9.9'
  spec.add_dependency 'grape-swagger', '~> 0.5.0'
end
