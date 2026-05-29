# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape-swagger-ui/version'

Gem::Specification.new do |gem|
  gem.name          = "grape-swagger-ui"
  gem.version       = Grape::Swagger::Ui::VERSION
  gem.authors       = ["Klaas Endrikat"]
  gem.email         = ["klaas.endrikat@googlemail.com"]
  gem.description   = %q{swagger ui js integration for grape and grape-swagger}
  gem.summary       = %q{swagger ui js integration for grape and grape-swagger}
  gem.license       = 'MIT'
  gem.homepage      = "https://github.com/kendrikat/grape-swagger-ui"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "railties", ">= 3.1"
end
