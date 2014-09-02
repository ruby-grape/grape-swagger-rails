require "bundler/gem_tasks"

desc "Run tests within test-app."
task :tests do
  path = File.expand_path('../test-app', __FILE__)
  Bundler.clean_exec "cd #{path}; bundle install; bundle exec rake"
end

task :default => :tests
