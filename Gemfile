source 'https://rubygems.org'

gemspec

case version = ENV['GRAPE_SWAGGER_VERSION'] || '~> 0.9.0'
when 'HEAD'
  gem 'grape-swagger', github: 'tim-vandecasteele/grape-swagger'
else
  gem 'grape-swagger', version
end
