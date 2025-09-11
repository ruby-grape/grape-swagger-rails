# frozen_string_literal: true

module GrapeSwaggerRails
  class Engine < ::Rails::Engine
    paths['lib/tasks'] = 'lib/tasks/exported'

    isolate_namespace GrapeSwaggerRails

    initializer 'grape_swagger_rails.assets', group: :all do |app|
      if app.config.respond_to?(:assets) && defined?(Sprockets)
        sprockets_4_or_later = Gem::Version.new(Sprockets::VERSION) >= Gem::Version.new('4')

        [
          'grape_swagger_rails/application.js',
          'grape_swagger_rails/application.css',
          'grape_swagger_rails/favicon.ico'
        ].each do |asset_path|
          app.config.assets.precompile << (sprockets_4_or_later ? asset_path : proc { |path| path == asset_path })
        end
      end
    end
  end
end
