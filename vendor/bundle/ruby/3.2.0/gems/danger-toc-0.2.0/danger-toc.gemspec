lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'toc/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'danger-toc'
  spec.version       = Toc::VERSION
  spec.authors       = ['dblock']
  spec.email         = ['dblock@dblock.org']
  spec.description   = 'A danger.systems plugin for your markdown TOC.'
  spec.summary       = 'A danger.systems plugin for your markdown TOC.'
  spec.homepage      = 'https://github.com/dblock/danger-toc'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'kramdown'
  spec.add_runtime_dependency 'danger-plugin-api', '~> 1.0'
end
