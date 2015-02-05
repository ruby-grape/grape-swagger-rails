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

  desc 'Get headers.'
  get '/headers' do
    request.headers.as_json
  end

  desc 'Get params.'
  get '/params' do
    request.params.as_json
  end

  add_swagger_documentation
end
