module GrapeSwaggerRails
  class ApplicationController < ActionController::Base
    before_filter do
      if GrapeSwaggerRails.options.before_filter
        instance_exec(request, &GrapeSwaggerRails.options.before_filter)
      end
    end

    def index
    end
  end
end
