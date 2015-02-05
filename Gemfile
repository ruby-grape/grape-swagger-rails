source 'https://rubygems.org'

gemspec

case version = ENV['GRAPE_SWAGGER_VERSION'] || '~> 0.9.0'
when 'HEAD'
  gem 'grape-swagger', github: 'tim-vandecasteele/grape-swagger'
when '0.7.2'
  gem 'grape', '0.9.0'
  gem 'grape-swagger', '0.7.2'
when '0.8.0'
  gem 'grape', '0.9.0'
  gem 'grape-swagger', '0.8.0'
else
  gem 'grape-swagger', version
end
