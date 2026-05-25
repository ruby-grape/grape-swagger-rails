# frozen_string_literal: true

require 'haml/railtie'
require 'grape-swagger-rails/engine'
require 'ostruct'

module GrapeSwaggerRails
  class Options < OpenStruct
    def before_filter(&)
      GrapeSwaggerRails.deprecator.warn(
        'This option is deprecated and going to be removed in 1.0.0. ' \
        'Please use `before_action` instead'
      )
      before_action(&)
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
    url: '/swagger_doc',
    urls: nil,
    swagger_ui_config: {},
    app_name: 'Swagger',
    app_url: '',

    headers: {},

    api_auth: '', # 'basic' or 'bearer'
    api_key_name: 'api_key', # 'Authorization'
    api_key_type: 'query', # 'header'
    api_key_default_value: '', # Auto populates api_key
    api_key_placeholder: 'api_key', # Placeholder for api_key input

    theme: 'light',

    doc_expansion: 'none',
    supported_submit_methods: %w[get post put delete patch],

    before_action_proc: nil, # Proc used as a controller before action

    display: {
      api_key_input: true,
      info_url: true,
      doc_version: true,
      version_stamp: true,
      clear_button: false
    }
  )

  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('1.0', 'GrapeSwaggerRails')
  end
end
