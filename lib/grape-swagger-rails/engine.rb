# frozen_string_literal: true

module GrapeSwaggerRails
  class Engine < ::Rails::Engine
    paths['lib/tasks'] = 'lib/tasks/exported'

    isolate_namespace GrapeSwaggerRails

    initializer 'grape_swagger_rails.assets', group: :all do |app|
      if app.config.respond_to?(:assets) && defined?(Sprockets)
        sprockets_4_or_later = Gem::Version.new(Sprockets::VERSION) >= Gem::Version.new('4')

        %w[
          grape_swagger_rails/favicon.ico
          grape_swagger_rails/swagger-ui.css
          grape_swagger_rails/index.css
          grape_swagger_rails/index.js
          grape_swagger_rails/swagger-ui-bundle.js
          grape_swagger_rails/swagger-ui-standalone-preset.js
          grape_swagger_rails/favicon-16x16.png
          grape_swagger_rails/favicon-32x32.png
        ].each do |asset_path|
          app.config.assets.precompile << (sprockets_4_or_later ? asset_path : proc { |path| path == asset_path })
        end
      end
    end
  end
end
