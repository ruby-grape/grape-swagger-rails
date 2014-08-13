require "grape-swagger-rails/engine"

module GrapeSwaggerRails
  class Options < Struct.new(:url, :api_key_name, :api_key_type, :api_auth, :headers, :app_name, :app_url, :authentication_proc)
    def authenticate_with(&block)
      self.authentication_proc = block
    end
  end

  mattr_accessor :options

  self.options = Options.new(

    url:                  '/swagger_doc.json',
    app_name:             'Swagger',
    app_url:              'http://swagger.wordnik.com',

    headers:              {},

    api_auth:             '',        # 'basic' or 'bearer'
    api_key_name:         'api_key', # 'Authorization'
    api_key_type:         'query',   # 'header'

    authentication_proc:  nil # Proc used as a controller before filter that returns a boolean
  )

end
