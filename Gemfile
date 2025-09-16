# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

case grape_swagger_version = ENV.fetch('GRAPE_SWAGGER_VERSION', '~> 1.6.0')
when 'HEAD'
  gem 'grape-swagger', github: 'ruby-grape/grape-swagger'
else
  gem 'grape', '>= 1.3.0'
  gem 'grape-swagger', grape_swagger_version
end

case rails_version = ENV.fetch('RAILS_VERSION', '>= 6.0.6.1')
when 'edge'
  gem 'railties', github: 'rails/rails', branch: 'main'
else
  gem 'railties', rails_version
end

group :development, :test do
  gem 'capybara'
  gem 'grape-swagger-ui'
  gem 'jquery-rails'
  gem 'mime-types'
  gem 'nokogiri'
  gem 'propshaft', require: false
  gem 'rack', '< 3.0'
  gem 'rack-cors'
  gem 'rake'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'ruby-grape-danger', '~> 0.2.0', require: false
  gem 'selenium-webdriver'
  gem 'sprockets', ENV.fetch('SPROCKETS_VERSION', '>= 4.0.0'), require: false
  gem 'sprockets-rails', require: false
  gem 'uglifier'
  gem 'webrick'
end
