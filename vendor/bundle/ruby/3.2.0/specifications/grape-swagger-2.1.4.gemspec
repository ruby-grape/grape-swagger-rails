# -*- encoding: utf-8 -*-
# stub: grape-swagger 2.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "grape-swagger".freeze
  s.version = "2.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["LeFnord".freeze, "Tim Vandecasteele".freeze]
  s.date = "2026-02-03"
  s.email = ["pscholz.le@gmail.com".freeze, "tim.vandecasteele@gmail.com".freeze]
  s.homepage = "https://github.com/ruby-grape/grape-swagger".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Add auto generated documentation to your Grape API that can be displayed with Swagger.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<grape>.freeze, [">= 1.7", "< 4.0"])
end
