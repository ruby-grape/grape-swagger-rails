module GrapeSwaggerRails
  class ApplicationController < ActionController::Base
    before_filter do
      if GrapeSwaggerRails.options.authentication_proc
        instance_exec(request, &GrapeSwaggerRails.options.authentication_proc)
      end
    end
    
    def index
    end
  end
end
