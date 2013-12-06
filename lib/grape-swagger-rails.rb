require "grape-swagger-rails/engine"

module GrapeSwaggerRails
  class Options < Struct.new(:url, :api_key_name, :api_key_type, :api_auth, :headers, :app_name, :app_url)
  end
  
  mattr_accessor :options
  
  self.options = Options.new(
    url:          '/swagger_doc.json',
    api_key_name: 'api_key',
    api_key_type: 'query',
    api_auth:     '', # 'basic'
    headers:      {},
    app_name:     'Swagger',
    app_url:      'http://swagger.wordnik.com'
  )
  
end

