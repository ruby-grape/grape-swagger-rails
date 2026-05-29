module Swagger
  module Generators
    class LayoutGenerator < ::Rails::Generators::Base
      desc 'Setup a dedicated layout for the swagger-ui'
      argument :template_engine, :type => :string, :default => "erb"

      def self.source_root
        File.expand_path('../templates', __FILE__)
      end

      def create_swagger_layout
        template "swagger.html.#{template_engine.underscore}", File.join('app', 'views', 'layouts', "swagger.html.#{template_engine.underscore}")
      end        
    end
  end
end