# -*- encoding: utf-8 -*-
# stub: danger-changelog 0.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "danger-changelog".freeze
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["dblock".freeze]
  s.date = "1980-01-02"
  s.description = "A danger.systems plugin that is OCD about your CHANGELOG.".freeze
  s.email = ["dblock@dblock.org".freeze]
  s.homepage = "https://github.com/dblock/danger-changelog".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "A danger.systems plugin that is OCD about your CHANGELOG.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<danger-plugin-api>.freeze, ["~> 1.0"])
end
