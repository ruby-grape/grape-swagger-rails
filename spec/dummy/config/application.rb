require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'jquery-rails'

Bundler.require(*Rails.groups)
require 'grape-swagger-rails'

module Dummy
  class Application < Rails::Application
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
  end
end
