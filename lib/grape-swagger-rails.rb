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

    url:                    '/swagger_doc',
    app_name:               'Swagger',
    app_url:                'http://swagger.wordnik.com',

    headers:                {},

    api_auth:               '', # 'basic' or 'bearer'
    api_key_name:           'api_key', # 'Authorization'
    api_key_type:           'query', # 'header'
    api_key_default_value:  '', # Auto populates api_key

    doc_expansion:          'none',
    supported_submit_methods: %w(get post put delete patch),

    before_filter_proc:     nil, # Proc used as a controller before filter

    hide_url_input:         false,
    hide_api_key_input:     false
  )
end
