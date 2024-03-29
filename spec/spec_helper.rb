# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('dummy/config/environment.rb', __dir__)
require 'rspec/rails'

Rails.backtrace_cleaner.remove_silencers!

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each do |f|
  require f
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end
