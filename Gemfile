source 'https://rubygems.org'

gemspec

case version = ENV['GRAPE_SWAGGER_VERSION'] || '~> 0.9.0'
when 'HEAD'
  gem 'grape-swagger', github: 'tim-vandecasteele/grape-swagger'
when '0.8.0'
  gem 'grape', '0.9.0'
  gem 'grape-swagger', '0.8.0'
when '0.9.0'
  gem 'grape', '0.10.1'
  gem 'grape-swagger', '0.9.0'
when '0.11.0'
  gem 'grape', '0.16.2'
  gem 'grape-swagger', '0.11.0'
when '0.20.2'
  gem 'grape', '0.14.0'
  gem 'grape-swagger', '0.20.2'
else
  gem 'grape-swagger', version
end

group :test do
  gem 'ruby-grape-danger', '~> 0.1.0', require: false
end
