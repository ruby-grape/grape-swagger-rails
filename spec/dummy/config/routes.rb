# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
