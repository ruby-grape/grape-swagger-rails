# -*- encoding: utf-8 -*-
# stub: danger-toc 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "danger-toc".freeze
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["dblock".freeze]
  s.date = "2019-07-28"
  s.description = "A danger.systems plugin for your markdown TOC.".freeze
  s.email = ["dblock@dblock.org".freeze]
  s.homepage = "https://github.com/dblock/danger-toc".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "A danger.systems plugin for your markdown TOC.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<kramdown>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<danger-plugin-api>.freeze, ["~> 1.0"])
end
