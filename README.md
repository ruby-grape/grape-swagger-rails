# GrapeSwaggerRails

[![Gem Version](https://badge.fury.io/rb/grape-swagger-rails.svg)](http://badge.fury.io/rb/grape-swagger-rails)
[![Build Status](https://travis-ci.org/ruby-grape/grape-swagger-rails.svg)](https://travis-ci.org/ruby-grape/grape-swagger-rails)
[![Dependency Status](https://gemnasium.com/ruby-grape/grape-swagger-rails.svg)](https://gemnasium.com/ruby-grape/grape-swagger-rails)
[![Code Climate](https://codeclimate.com/github/ruby-grape/grape-swagger-rails/badges/gpa.svg)](https://codeclimate.com/github/ruby-grape/grape-swagger-rails)

Swagger UI as Rails Engine for grape-swagger gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grape-swagger-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape-swagger-rails

## Compatibility

GrapeSwaggerRails is compatible with the following versions of grape and grape-swagger.

grape  | grape-swagger
-------|--------------
0.9.0  | 0.8.0
0.10.0 | 0.9.0
0.16.2 | 0.20.2

## Usage

Add this line to `./config/routes.rb`:

```ruby
mount GrapeSwaggerRails::Engine => '/swagger'
```

Create an initializer (e.g. `./config/initializers/swagger.rb`) and specify the URL to your Swagger API schema and app:

```ruby
GrapeSwaggerRails.options.url      = '/swagger_doc.json'
GrapeSwaggerRails.options.app_url  = 'http://swagger.wordnik.com'
```

You can dynamically set `app_url` for each request use a `before_action`:

```ruby
GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end
```

You can set the app name, default is "Swagger".

``` ruby
GrapeSwaggerRails.options.app_name = 'Swagger'
```

You can specify additional headers to add to each request:

```ruby
GrapeSwaggerRails.options.headers['Special-Header'] = 'Some Secret Value'
```

You can set docExpansion with "none" or "list" or "full", default is "none".
See the official Swagger-UI documentation about [SwaggerUi Parameters](https://github.com/swagger-api/swagger-ui#parameters).

```ruby
GrapeSwaggerRails.options.doc_expansion = 'list'
```

You can set supportedSubmitMethods with an array of the supported HTTP methods, default is `%w{ get post put delete patch }`.

See the official Swagger-UI documentation about [SwaggerUi Parameters](https://github.com/swagger-api/swagger-ui#parameters).

```ruby
GrapeSwaggerRails.options.supported_submit_methods = ["get"]
```

You can set validatorUrl to your own locally deployed Swagger validator, or disable validation by setting this option to nil.
This is useful to avoid error messages when running Swagger-UI on a server which is not accessible from outside your network.

```ruby
GrapeSwaggerRails.options.validator_url = nil
```

Using the `headers` option above, you could hard-code Basic Authentication credentials.
Alternatively, you can configure Basic Authentication through the UI, as described below.

### Basic Authentication

If your application uses Basic Authentication, you can setup Swagger to send the username and password to the server with each request to your API:

```ruby
GrapeSwaggerRails.options.api_auth     = 'basic' # Or 'bearer' for OAuth
GrapeSwaggerRails.options.api_key_name = 'Authorization'
GrapeSwaggerRails.options.api_key_type = 'header'
```

Now you can specify the username and password to your API in the Swagger "API key" field by concatenating the values like this:

    username:password

The javascript that loads on the Swagger page automatically encodes the username and password and adds the authorization header to your API request.
See the official Swagger documentation about [Custom Header Parameters](https://github.com/wordnik/swagger-ui#custom-header-parameters---for-basic-auth-etc)

### Pre-fill Authentication

If you will know the Authentication key prior to page load or you wish to set it for debug purposes, you can setup so that the `api_key` field is pre-filled on page load:

```ruby
GrapeSwaggerRails.options.api_key_default_value = 'your_default_value'
```

To set it based on the `current_user` or other request-based parameters, try using it inside of your `before_action` (See Swagger UI Authorization)

### API Token Authentication

If your application uses token authentication passed as a query param, you can setup Swagger to send the API token along with each request to your API:

```ruby
GrapeSwaggerRails.options.api_key_name = 'api_token'
GrapeSwaggerRails.options.api_key_type = 'query'
```

You can use the ```api_key``` input box to fill in your API token.
### Swagger UI Authorization

You may want to authenticate users before displaying the Swagger UI, particularly when the API is protected by Basic Authentication.
Use the `before` option to inspect the request before Swagger UI:

```ruby
GrapeSwaggerRails.options.before_action do |request|
  # 1. Inspect the `request` or access the Swagger UI controller via `self`.
  # 2. Check `current_user` or `can? :access, :api`, etc.
  # 3. Redirect or error in case of failure.
end
```

#### Integration with DoorKeeper

Add the following code to the initializer (swagger.rb):

```ruby
GrapeSwaggerRails.options.before_action do |request|
  GrapeSwaggerRails.options.api_key_default_value = current_user.token.token
end
```

In your User model (user.rb) add:

```ruby
has_one :token, -> { order 'created_at DESC' }, class_name: Doorkeeper::AccessToken, foreign_key: :resource_owner_id
```

### Hiding the API or Authorization text boxes

If you know in advance that you would like to prevent changing the Swagger API URL, you can hide it using the following:

```ruby
GrapeSwaggerRails.options.hide_url_input = true
```

Similarly, you can hide the Authentication input box by adding this:

```ruby
GrapeSwaggerRails.options.hide_api_key_input = true
```

By default, these options are false.

### Updating Swagger UI from Dist

To update Swagger UI from its [distribution](https://github.com/wordnik/swagger-ui), run `bundle exec rake swagger_ui:dist:update`. Examine the changes carefully.

NOTE: This action should be run part of this gem (not your application). In case if you want to
make it up-to-date, clone the repo, run the rake task, examine the diff, fix any bugs, make sure
tests pass and then send PR here.

### Enabling in a Rails-API Project

The grape-swagger-rails gem uses the Rails asset pipeline for its Javascript and CSS. Enable the asset pipeline with [rails-api](https://github.com/rails-api/rails-api).

Add sprockets to `config/application.rb`.

```ruby
require 'sprockets/railtie'
```

Include JavaScript in `app/assets/javascripts/application.js`.

```javascript
//
//= require_tree .
```

Include CSS stylesheets in `app/assets/stylesheets/application.css`.

```css
/*
*= require_tree .
*/
```

## Contributors

* [unloved](https://github.com/unloved)
* [dapi](https://github.com/dapi)
* [joelvh](https://github.com/joelvh)
* [dblock](https://github.com/dblock)
* ... and [more](https://github.com/ruby-grape/grape-swagger-rails/graphs/contributors) ...

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## License

MIT License, see [LICENSE](LICENSE.txt).
