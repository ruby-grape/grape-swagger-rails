require 'grape-swagger-rails/engine'

module GrapeSwaggerRails
  class Options < OpenStruct
    def before_filter(&block)
      if block_given?
        self.before_filter_proc = block
      else
        before_filter_proc
      end
    end
  end

  mattr_accessor :options

  self.options = Options.new(

    url:                  '/swagger_doc',
    app_name:             'Swagger',
    app_url:              'http://swagger.wordnik.com',

    headers:              {},

    api_auth:             '',        # 'basic' or 'bearer'
    api_key_name:         'api_key', # 'Authorization'
    api_key_type:         'query',   # 'header'

    before_filter_proc:   nil # Proc used as a controller before filter
  )
end
