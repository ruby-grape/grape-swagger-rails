#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path('../spec/dummy/Rakefile', __FILE__)

load 'rails/tasks/engine.rake'
Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), 'lib/tasks/**/*.rake')].each do |f|
  load f
end

require 'rspec/core'
require 'rspec/core/rake_task'

desc 'Run all specs.'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: [:rubocop, :spec]
