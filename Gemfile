source 'https://rubygems.org'

gemspec

case version = ENV['GRAPE_SWAGGER_VERSION'] || '~> 1.6.0'
when 'HEAD'
  gem 'grape-swagger', github: 'ruby-grape/grape-swagger'
else
  gem 'grape-swagger', version
  gem 'grape', '>= 1.3.0'
end

group :development, :test do
  gem 'capybara'
  gem 'coffee-rails'
  gem 'grape-swagger-ui'
  gem 'jquery-rails'
  gem 'mime-types'
  gem 'nokogiri'
  gem 'rack', '< 3.0'
  gem 'rack-cors'
  gem 'rack-no_animations'
  gem 'rake'
  gem 'rspec-rails'
  gem 'rubocop', '0.77.0'
  gem 'ruby-grape-danger', '~> 0.2.0', require: false
  gem 'sass'
  gem 'sass-rails'
  gem 'selenium-webdriver'
  gem 'sprockets'
  gem 'uglifier'
  gem 'webrick'
end
