# -*- encoding: utf-8 -*-
# stub: cork 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "cork".freeze
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Karla Sandoval".freeze, "Orta Therox".freeze]
  s.date = "2017-04-11"
  s.email = ["k.isabel.sandoval@gmail.com".freeze, "orta.therox@gmail.com".freeze]
  s.homepage = "https://github.com/CocoaPods/Cork".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "A delightful CLI UI module.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 3

  s.add_runtime_dependency(%q<colored2>.freeze, ["~> 3.1"])
  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.3"])
  s.add_development_dependency(%q<rake>.freeze, [">= 10.0"])
  s.add_development_dependency(%q<bacon>.freeze, ["~> 1.1"])
end
