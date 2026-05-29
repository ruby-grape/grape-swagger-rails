Rails.application.routes.draw do
  get "/api/swagger", :to => 'swagger#index', :as => 'api_swagger'
end

