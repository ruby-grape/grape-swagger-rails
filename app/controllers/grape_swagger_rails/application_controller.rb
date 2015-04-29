module GrapeSwaggerRails
  class ApplicationController < ActionController::Base
    before_filter do
      if GrapeSwaggerRails.options.before_filter
        instance_exec(request, &GrapeSwaggerRails.options.before_filter)
      end
    end

    def index
      @api_key_value = cookies['accessToken']
    end
  end
end
