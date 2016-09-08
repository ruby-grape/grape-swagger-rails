module GrapeSwaggerRails
  class ApplicationController < ActionController::Base
    before_action do
      if GrapeSwaggerRails.options.before_action
        instance_exec(request, &GrapeSwaggerRails.options.before_action)
      end
    end

    def index
    end
  end
end
