require 'grape-swagger-rails/engine'

module GrapeSwaggerRails
  class Options < OpenStruct
    def before_filter(&block)
      ActiveSupport::Deprecation.warn('This option is deprecated and going to be removed in 1.0.0. ' \
                                      'Please use `before_action` instead')
      before_action(&block)
    end

    def before_action(&block)
      if block_given?
        self.before_action_proc = block
      else
        before_action_proc
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

    before_action_proc:     nil, # Proc used as a controller before action

    hide_url_input:         false,
    hide_api_key_input:     false
  )
end
