# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

case version = ENV['GRAPE_SWAGGER_VERSION'] || '~> 1.6.0'
when 'HEAD'
  gem 'grape-swagger', github: 'ruby-grape/grape-swagger'
else
  gem 'grape', '>= 1.3.0'
  gem 'grape-swagger', version
end

group :development, :test do
  gem 'capybara'
  gem 'grape-swagger-ui'
  gem 'jquery-rails'
  gem 'mime-types'
  gem 'nokogiri'
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
  gem 'sprockets-rails', require: 'sprockets/railtie'
  gem 'uglifier'
  gem 'webrick'
end
