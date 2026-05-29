lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'changelog/gem_version'

Gem::Specification.new do |spec|
  spec.name          = 'danger-changelog'
  spec.version       = Changelog::VERSION
  spec.authors       = ['dblock']
  spec.email         = ['dblock@dblock.org']
  spec.description   = 'A danger.systems plugin that is OCD about your CHANGELOG.'
  spec.summary       = 'A danger.systems plugin that is OCD about your CHANGELOG.'
  spec.homepage      = 'https://github.com/dblock/danger-changelog'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'danger-plugin-api', '~> 1.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
