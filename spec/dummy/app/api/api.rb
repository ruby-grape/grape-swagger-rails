# frozen_string_literal: true

class API < Grape::API
  prefix 'api'

  namespace :foos do
    desc 'Get foos.'
    get do
      [{ id: 1, name: 'Foo' }]
    end

    desc 'Get a foo.'
    params do
      requires :id, type: String, desc: 'Foo id.'
    end
    get :id do
      { id: 1, name: 'Foo' }
    end
  end

  desc 'Get headers.', security: [{ api_key: [] }]
  get '/headers' do
    request.headers.as_json
  end

  desc 'Get params.'
  get '/params' do
    request.params.as_json
  end

  desc 'Echo request body and headers.',
       consumes: ['application/x-www-form-urlencoded']
  params do
    requires :name, type: String, desc: 'Name.'
    optional :enabled, type: Boolean, desc: 'Enabled flag.'
  end
  post '/echo' do
    request.body.rewind
    raw_body = request.body.read

    {
      body: raw_body,
      content_type: request.content_type,
      headers: {
        'X-Test-Header' => request.headers['X-Test-Header'] || request.headers['HTTP_X_TEST_HEADER']
      },
      params: declared(params, include_missing: false).as_json
    }
  end

  desc 'Submit data as JSON.',
       consumes: ['application/json']
  params do
    requires :name, type: String, desc: 'Name.'
    optional :enabled, type: Boolean, desc: 'Enabled flag.'
  end
  post '/submit' do
    {
      content_type: request.content_type,
      params: declared(params, include_missing: false).as_json
    }
  end

  desc 'Create a resource accepting either JSON or form-encoded body.',
       consumes: %w[application/json application/x-www-form-urlencoded]
  params do
    requires :name, type: String, desc: 'Name.'
    optional :enabled, type: Boolean, desc: 'Enabled flag.'
  end
  post '/create' do
    {
      content_type: request.content_type,
      params: declared(params, include_missing: false).as_json
    }
  end

  add_swagger_documentation(
    security_definitions: {
      api_key: {
        type: 'apiKey',
        name: 'Authorization',
        in: 'header',
        description: <<~HTML
          The default API authentication token.
          <br>
          <br>
          Fetch a token using the <code>POST /api/sign_in</code> endpoint.<br>
          Then use the following format: <code>Bearer {token}</code>, or include additional information with <code>one extra code block</code>, <code>another extra code block</code>, <code>BLOCK 1</code>, <code>Second block</code>, <code>Third block</code>, and <code>Last block</code>.
        HTML
      }
    }
  )
end

class APIv2 < Grape::API
  prefix 'api'
  version 'v2', using: :path

  desc 'Get API v2 status.'
  get '/status' do
    { version: 'v2', status: 'ok' }
  end

  add_swagger_documentation
end
