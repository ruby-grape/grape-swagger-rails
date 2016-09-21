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
      return unless GrapeSwaggerRails.options.before_action
      instance_exec(request, &GrapeSwaggerRails.options.before_action)
    end
  end
end
