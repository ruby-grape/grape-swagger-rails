# -*- encoding: utf-8 -*-
# stub: danger-plugin-api 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "danger-plugin-api".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Orta Therox".freeze]
  s.bindir = "exe".freeze
  s.date = "2016-08-25"
  s.description = "An empty gem, which provides a SemVer link for the Danger plugin API.".freeze
  s.email = ["orta.therox@gmail.com".freeze]
  s.homepage = "https://github.com/danger/danger-plugin-api".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "An empty gem, which provides a SemVer link for the Danger plugin API.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<danger>.freeze, ["> 2.0"])
  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.12"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
end
