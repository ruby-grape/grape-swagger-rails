# -*- encoding: utf-8 -*-
# stub: haml-rails 3.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "haml-rails".freeze
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 2.0.0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andr\u00E9 Arko".freeze]
  s.date = "1980-01-02"
  s.description = "Haml-rails provides Haml generators for Rails 5.1 and above. It also enables Haml as the templating engine for you, so you don't have to screw around in your own application.rb when your Gemfile already clearly indicated what templating engine you have installed. Hurrah.".freeze
  s.email = ["andre@arko.net".freeze]
  s.homepage = "https://github.com/haml/haml-rails".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "let your Gemfile do the configuring".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<haml>.freeze, [">= 4.0.6"])
  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 5.1"])
  s.add_runtime_dependency(%q<actionpack>.freeze, [">= 5.1"])
  s.add_runtime_dependency(%q<railties>.freeze, [">= 5.1"])
  s.add_development_dependency(%q<html2haml>.freeze, [">= 1.0.1"])
  s.add_development_dependency(%q<rails>.freeze, [">= 5.1"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
end
