# frozen_string_literal: true

module GrapeSwaggerRails
  # View helpers for the Swagger UI page.
  module ApplicationHelper
    DISPLAY_DEFAULTS = {
      api_key_input: true,
      doc_version: true,
      info_url: true,
      validator_badge: true,
      version_stamp: true
    }.freeze

    def swagger_data_attributes
      options = GrapeSwaggerRails.options
      display = DISPLAY_DEFAULTS.merge((options.display || {}).transform_keys(&:to_sym))

      {
        swagger_options: options.marshal_dump.to_json,
        hide_api_key: !display[:api_key_input],
        hide_info_url: !display[:info_url]
      }
    end

    def grape_swagger_rails_runtime_asset
      Rails.env.production? ? 'grape_swagger_rails/index.min' : 'grape_swagger_rails/index'
    end
  end
end
