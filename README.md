# GrapeSwaggerRails

Swagger UI as Rails Engine for grape-swagger gem

## Installation

Add this line to your application's Gemfile:

    gem 'grape-swagger-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape-swagger-rails

## Usage: add this line to your routes.rb

    mount GrapeSwaggerRails::Engine => '/swagger'

Create `./config/initializer/swagger.rb` with lines:

    GrapeSwaggerRails.discoveryUrl = "/swagger_doc.json"
    GrapeSwaggerRails.appName      = 'Swagger'
    GrapeSwaggerRails.appUrl       = 'http://swagger.wordnik.com'

    
## Нюансы

Чтобы избежать проблемы с валидацией параметров в `POST` запросах, используе этот gem:

    gem 'grape-swagger', :git=>'git://github.com/jhecking/grape-swagger.git'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
