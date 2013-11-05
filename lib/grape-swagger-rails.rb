require "grape-swagger-rails/engine"

module GrapeSwaggerRails
  mattr_accessor :discoveryUrl, :apiKey, :headers, 
                 :appName, :appUrl

  self.discoveryUrl = '/swagger_doc.json'
  self.apiKey       = 'special-key'
  self.headers      = {}
  self.appName      = 'Swagger'
  self.appUrl       = 'http://swagger.wordnik.com'
end

