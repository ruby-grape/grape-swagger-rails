require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:specs)

task default: %i[rubocop specs]

task :spec do
  Rake::Task['specs'].invoke
  Rake::Task['rubocop'].invoke
  Rake::Task['spec_docs'].invoke
end

desc 'Run RuboCop on the lib/specs directory'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb', 'spec/**/*.rb']
end

desc 'Ensure that the plugin passes `danger plugins lint`'
task :spec_docs do
  sh 'bundle exec danger plugins lint'
end
