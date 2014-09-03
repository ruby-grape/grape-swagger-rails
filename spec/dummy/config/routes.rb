Rails.application.routes.draw do
  root 'welcome#index'
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
