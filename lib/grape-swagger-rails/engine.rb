module GrapeSwaggerRails
  class Engine < ::Rails::Engine
    paths['lib/tasks'] = 'lib/tasks/exported'
    isolate_namespace GrapeSwaggerRails
  end
end
