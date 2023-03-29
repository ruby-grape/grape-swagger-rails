require 'bundler/setup'

APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

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
