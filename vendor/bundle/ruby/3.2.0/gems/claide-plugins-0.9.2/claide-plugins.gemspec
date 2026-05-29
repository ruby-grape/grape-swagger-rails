# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'claide_plugins.rb'

Gem::Specification.new do |spec|
  spec.name          = 'claide-plugins'
  spec.version       = CLAidePlugins::VERSION
  spec.authors       = ['David Grandinetti', 'Olivier Halligon']
  spec.summary       = %q{CLAide plugin which shows info about available CLAide plugins.}
  spec.description   = <<-DESC
                         This CLAide plugin shows information about all available CLAide plugins
                         (yes, this is very meta!).
                         This plugin adds the "plugins" subcommand to a binary so that you can list
                         all plugins (registered in the reference JSON hosted at CocoaPods/cocoapods-plugins)
                       DESC
  spec.homepage      = 'https://github.com/cocoapods/claide-plugins'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nap'
  spec.add_runtime_dependency 'cork'
  spec.add_runtime_dependency 'open4', '~> 1.3'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'

  spec.required_ruby_version = '>= 2.0.0'
end
