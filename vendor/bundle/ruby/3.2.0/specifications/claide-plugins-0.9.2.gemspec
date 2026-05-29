# -*- encoding: utf-8 -*-
# stub: claide-plugins 0.9.2 ruby lib

Gem::Specification.new do |s|
  s.name = "claide-plugins".freeze
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Grandinetti".freeze, "Olivier Halligon".freeze]
  s.date = "2016-10-02"
  s.description = "                         This CLAide plugin shows information about all available CLAide plugins\n                         (yes, this is very meta!).\n                         This plugin adds the \"plugins\" subcommand to a binary so that you can list\n                         all plugins (registered in the reference JSON hosted at CocoaPods/cocoapods-plugins)\n".freeze
  s.homepage = "https://github.com/cocoapods/claide-plugins".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "CLAide plugin which shows info about available CLAide plugins.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<nap>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<cork>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<open4>.freeze, ["~> 1.3"])
  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.3"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<pry>.freeze, [">= 0"])
end
