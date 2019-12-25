module GrapeSwaggerRails
  class ApplicationController < ActionController::Base

    # HTTP Base Auth
    if GrapeSwaggerRails.options.http_base_auth_name.present? && GrapeSwaggerRails.options.http_base_auth_password.present?
      http_basic_authenticate_with name: GrapeSwaggerRails.options.http_base_auth_name,
                                   password: GrapeSwaggerRails.options.http_base_auth_password
    end

    if Rails::VERSION::MAJOR >= 4
      before_action { run_before_action }
    else
      before_filter { run_before_action }
    end

    def index
    end

    private

    def run_before_action
      return unless GrapeSwaggerRails.options.before_action
      instance_exec(request, &GrapeSwaggerRails.options.before_action)
    end
  end
end
