module GrapeSwaggerRails
  class ApplicationController < ActionController::Base

    if Rails::VERSION::MAJOR >= 4
      before_action { run_before_action }
    else
      before_filter { run_before_action }
    end

    def index
    end

    private

    def run_before_action
      callback = [GrapeSwaggerRails.options.before_action, GrapeSwaggerRails.options.before_filter].compact.first
      instance_exec(request, &callback) if callback
    end
  end
end
