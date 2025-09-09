# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

asset_pipeline = ENV.fetch('ASSET_PIPELINE', 'sprockets')
case asset_pipeline
when 'propshaft'
  require 'rails/railtie'
  require 'propshaft'
else
  require 'sprockets/railtie'
end

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
