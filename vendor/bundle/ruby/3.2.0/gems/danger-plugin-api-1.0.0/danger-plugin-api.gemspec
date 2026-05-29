# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'danger/plugin/api/version'

Gem::Specification.new do |spec|
  spec.name          = "danger-plugin-api"
  spec.version       = Danger::Plugin::Api::VERSION
  spec.authors       = ["Orta Therox"]
  spec.email         = ["orta.therox@gmail.com"]

  spec.summary       = %q{An empty gem, which provides a SemVer link for the Danger plugin API.}
  spec.description   = %q{An empty gem, which provides a SemVer link for the Danger plugin API.}
  spec.homepage      = "https://github.com/danger/danger-plugin-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "danger", "> 2.0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
