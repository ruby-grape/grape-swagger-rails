# frozen_string_literal: true

module GrapeSwaggerRails
  # View helpers for the Swagger UI page.
  module ApplicationHelper
    def swagger_data_attributes
      options = GrapeSwaggerRails.options
      display_defaults = { api_key_input: true, info_url: true, doc_version: true, version_stamp: true }
      display = display_defaults.merge((options.display || {}).transform_keys(&:to_sym))

      {
        swagger_options: options.marshal_dump.to_json,
        hide_api_key: !display[:api_key_input],
        hide_info_url: !display[:info_url]
      }
    end
  end
end
