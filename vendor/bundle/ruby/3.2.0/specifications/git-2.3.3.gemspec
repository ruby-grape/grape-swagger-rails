# -*- encoding: utf-8 -*-
# stub: git 2.3.3 ruby lib

Gem::Specification.new do |s|
  s.name = "git".freeze
  s.version = "2.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://rubydoc.info/gems/git/2.3.3/file/CHANGELOG.md", "documentation_uri" => "https://rubydoc.info/gems/git/2.3.3", "homepage_uri" => "http://github.com/ruby-git/ruby-git", "source_code_uri" => "http://github.com/ruby-git/ruby-git" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Scott Chacon and others".freeze]
  s.date = "2024-12-04"
  s.description = "The git gem provides an API that can be used to\ncreate, read, and manipulate Git repositories by wrapping system calls to the git\ncommand line. The API can be used for working with Git in complex interactions\nincluding branching and merging, object inspection and manipulation, history, patch\ngeneration and more.\n".freeze
  s.email = "schacon@gmail.com".freeze
  s.homepage = "http://github.com/ruby-git/ruby-git".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0.0".freeze)
  s.requirements = ["git 2.28.0 or greater".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "An API to create, read, and manipulate Git repositories".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 5.0"])
  s.add_runtime_dependency(%q<addressable>.freeze, ["~> 2.8"])
  s.add_runtime_dependency(%q<process_executer>.freeze, ["~> 1.1"])
  s.add_runtime_dependency(%q<rchardet>.freeze, ["~> 1.8"])
  s.add_development_dependency(%q<create_github_release>.freeze, ["~> 1.4"])
  s.add_development_dependency(%q<minitar>.freeze, ["~> 0.9"])
  s.add_development_dependency(%q<mocha>.freeze, ["~> 2.1"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.1"])
  s.add_development_dependency(%q<test-unit>.freeze, ["~> 3.6"])
  s.add_development_dependency(%q<redcarpet>.freeze, ["~> 3.6"])
  s.add_development_dependency(%q<yard>.freeze, ["~> 0.9", ">= 0.9.28"])
  s.add_development_dependency(%q<yardstick>.freeze, ["~> 0.9"])
end
