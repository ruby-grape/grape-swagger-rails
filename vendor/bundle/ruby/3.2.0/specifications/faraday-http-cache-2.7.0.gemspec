# -*- encoding: utf-8 -*-
# stub: faraday-http-cache 2.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "faraday-http-cache".freeze
  s.version = "2.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Lucas Mazza".freeze, "George Guimar\u00E3es".freeze, "Gustavo Araujo".freeze]
  s.date = "1980-01-02"
  s.description = "Middleware to handle HTTP caching".freeze
  s.email = ["opensource@sourcelevel.io".freeze]
  s.homepage = "https://github.com/sourcelevel/faraday-http-cache".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.2.0".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "A Faraday middleware that stores and validates cache expiration.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<faraday>.freeze, [">= 0.8"])
end
