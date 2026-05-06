# frozen_string_literal: true

module GrapeSwaggerRails
  # View helpers for the Swagger UI page.
  module ApplicationHelper
    def swagger_data_attributes
      options = GrapeSwaggerRails.options

      {
        swagger_options: options.marshal_dump.to_json,
        hide_api_key: options.hide_api_key_input,
        hide_url: options.hide_url_input
      }
    end
  end
end
