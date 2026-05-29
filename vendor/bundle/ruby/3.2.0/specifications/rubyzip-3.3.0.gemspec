# -*- encoding: utf-8 -*-
# stub: rubyzip 3.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rubyzip".freeze
  s.version = "3.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/rubyzip/rubyzip/issues", "changelog_uri" => "https://github.com/rubyzip/rubyzip/blob/v3.3.0/Changelog.md", "documentation_uri" => "https://www.rubydoc.info/gems/rubyzip/3.3.0", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/rubyzip/rubyzip/tree/v3.3.0", "wiki_uri" => "https://github.com/rubyzip/rubyzip/wiki" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Robert Haines".freeze, "John Lees-Miller".freeze, "Alexander Simonov".freeze]
  s.date = "1980-01-02"
  s.email = ["hainesr@gmail.com".freeze, "jdleesmiller@gmail.com".freeze, "alex@simonov.me".freeze]
  s.homepage = "http://github.com/rubyzip/rubyzip".freeze
  s.licenses = ["BSD-2-Clause".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "rubyzip is a ruby module for reading and writing zip files".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.25"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.2"])
  s.add_development_dependency(%q<rdoc>.freeze, ["~> 6.11"])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.80.2"])
  s.add_development_dependency(%q<rubocop-performance>.freeze, ["~> 1.26.0"])
  s.add_development_dependency(%q<rubocop-rake>.freeze, ["~> 0.7.1"])
  s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.22.0"])
  s.add_development_dependency(%q<simplecov-lcov>.freeze, ["~> 0.8"])
end
