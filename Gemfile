# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

case grape_version = ENV.fetch('GRAPE_VERSION', '~> 2.2.0')
when 'HEAD'
  gem 'grape', github: 'ruby-grape/grape'
else
  gem 'grape', grape_version
end

case grape_swagger_version = ENV.fetch('GRAPE_SWAGGER_VERSION', '~> 2.1.3')
when 'HEAD'
  gem 'grape-swagger', github: 'ruby-grape/grape-swagger'
else
  gem 'grape-swagger', grape_swagger_version
end

case rails_version = ENV.fetch('RAILS_VERSION', '>= 7.2.3.1')
when 'edge'
  gem 'railties', github: 'rails/rails', branch: 'main'
else
  gem 'railties', rails_version
end

group :development, :test do
  gem 'capybara'
  gem 'danger', require: false
  gem 'danger-changelog', require: false
  gem 'danger-pr-comment', require: false
  gem 'danger-toc', require: false
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
  gem 'rubocop-rspec_rails'
  gem 'selenium-webdriver'
  gem 'sprockets', ENV.fetch('SPROCKETS_VERSION', '>= 4.0.0'), require: false
  gem 'sprockets-rails', require: false
  gem 'uglifier'
  gem 'webrick'
end
