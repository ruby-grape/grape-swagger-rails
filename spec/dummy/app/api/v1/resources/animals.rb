module V1
  module Resources
    class Animals < Grape::API
      namespace :animals do
        get do
          [{ id: 1, name: 'Foo' }]
        end
      end
    end
  end
end
