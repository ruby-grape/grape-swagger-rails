require 'rails/generators/named_base'
require 'zip/zip'

module GrapeSwagger
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      def self.source_root
        @_grape_swagger_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def install
        Zip::ZipFile.foreach(open('https://github.com/wordnik/swagger-ui/archive/master.zip')) do |zip_entry|
          zip_entry.extract(zip_entry.to_s.gsub('swagger-ui-master/dist/', 'public/apidoc/')) if zip_entry.to_s =~ /\/dist\//
        end

        file_name = 'public/apidoc/index.html'
        text = File.read(file_name)
        new_text = text.gsub('css/', '/apidoc/css/').gsub('lib/', '/apidoc/lib/').gsub('swagger-ui.js', '/apidoc/swagger-ui.js').gsub('images/', '/apidoc/images/').gsub('supportHeaderParams: false', 'supportHeaderParams: true').gsub('http://petstore.swagger.wordnik.com/api/api-docs.json', '/api/swagger_doc.json')
        File.open(file_name, 'w') { |file| file.puts new_text }

        template 'general_api.rb', 'app/api/general_api.rb'

        route "mount GeneralAPI => '/'"
      end
    end
  end
end