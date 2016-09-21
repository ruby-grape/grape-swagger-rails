module GrapeSwaggerRails
  class ApplicationController < ActionController::Base
    before_action do
      callback = [GrapeSwaggerRails.options.before_action, GrapeSwaggerRails.options.before_filter].compact.first
      instance_exec(request, &callback) if callback
    end

    def index
    end
  end
end
