require "grape-swagger-rails/engine"

module GrapeSwaggerRails
  mattr_accessor :discoveryUrl, :apiKey

  self.discoveryUrl = '/swagger_doc.json'
  self.apiKey = 'special-key'

end

