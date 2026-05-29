# -*- encoding: utf-8 -*-
# stub: danger-pr-comment 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "danger-pr-comment".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andrei Subbota".freeze]
  s.date = "1980-01-02"
  s.description = "Shared Dangerfile that exports a JSON report for posting Danger results as a PR comment.".freeze
  s.email = ["numbata@users.noreply.github.com".freeze]
  s.homepage = "https://github.com/numbata/danger-pr-comment".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Reusable workflows and shared Dangerfile for PR comment reporting.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<danger>.freeze, ["~> 9"])
end
