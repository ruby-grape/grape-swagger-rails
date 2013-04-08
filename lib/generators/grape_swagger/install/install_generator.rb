require 'rails/generators/named_base'
require 'zip/zip'

module GrapeSwagger
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      def self.source_root
        @_grape_swagger_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def install
        install_path = 'apidoc'
        swagger_ui_repo = 'https://github.com/wordnik/swagger-ui'
        api_path = 'api'

        Zip::ZipFile.foreach(open("#{swagger_ui_repo}/archive/master.zip")) do |zip_entry|
          zip_entry.extract(zip_entry.to_s.gsub('swagger-ui-master/dist/', "public/#{install_path}/")) if zip_entry.to_s =~ /\/dist\//
        end

        file_name = "public/#{install_path}/index.html"
        text = File.read(file_name)
        new_text = text.
            gsub('css/', "/#{install_path}/css/").
            gsub('lib/', "/#{install_path}/lib/").
            gsub('swagger-ui.js', "/#{install_path}/swagger-ui.js").
            gsub('images/', "/#{install_path}/images/").
            gsub('supportHeaderParams: false', 'supportHeaderParams: true').
            gsub('http://petstore.swagger.wordnik.com/api/api-docs.json', "/#{api_path}/swagger_doc.json")
        File.open(file_name, 'w') { |file| file.puts new_text }
      end
    end
  end
end