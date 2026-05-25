# frozen_string_literal: true

require 'fileutils'
require 'git'
require 'tmpdir'

namespace :swagger_ui do
  namespace :dist do
    desc 'Update Swagger UI assets from swagger-api/swagger-ui.'
    task :update do
      root = File.expand_path('../..', __dir__)
      version_file = File.join(root, 'lib/grape-swagger-rails/version.rb')
      match = File.read(version_file).match(/SWAGGER_UI_VERSION = '([^']+)'/)
      raise "Could not find SWAGGER_UI_VERSION in #{version_file}" unless match

      current_version = match[1]
      version = ENV.fetch('SWAGGER_UI_VERSION', "v#{current_version}")
      version = "v#{version}" unless version.start_with?('v')

      Dir.mktmpdir('swagger-ui') do |dir|
        puts "Cloning swagger-api/swagger-ui #{version} into #{dir} ..."
        Git.clone(
          'https://github.com/swagger-api/swagger-ui.git',
          'swagger-ui',
          path: dir,
          depth: 1,
          branch: version
        )

        dist = File.join(dir, 'swagger-ui', 'dist')

        raise "Missing dist directory at #{dist}" unless Dir.exist?(dist)

        swagger_path = 'app/assets/javascripts/grape_swagger_rails'
        puts "Copying JavaScript assets #{swagger_path} ..."
        {
          'swagger-ui-bundle.js' => File.join(root, swagger_path, 'swagger-ui-bundle.js'),
          'swagger-ui-standalone-preset.js' => File.join(root, swagger_path, 'swagger-ui-standalone-preset.js')
        }.each do |source_name, target|
          FileUtils.cp File.join(dist, source_name), target
        end

        puts 'Copying stylesheet assets ...'
        FileUtils.cp File.join(dist, 'swagger-ui.css'),
                     File.join(root, 'app/assets/stylesheets/grape_swagger_rails/swagger-ui.css')

        semver = version.sub(/\Av/, '')
        content = File.read(version_file)
        updated = content.gsub(/SWAGGER_UI_VERSION = '[^']*'/, "SWAGGER_UI_VERSION = '#{semver}'")
        File.write(version_file, updated)
        puts "Updated SWAGGER_UI_VERSION to #{semver} in #{version_file}"

        readme_file = File.join(root, 'README.md')
        readme = File.read(readme_file)
        compatibility_table = readme.match(/(## Compatibility.*?)(\n\nThe dummy app)/m)
        raise 'Could not find README compatibility table' unless compatibility_table

        updated_table = compatibility_table[1].gsub(
          /^(\|\s*[^|\n]+\|\s*[^|\n]+\|\s*[^|\n]+\|\s*[^|\n]+\|\s*)\d+\.\d+\.\d+(\s*\|)$/m,
          "\\1#{semver}\\2"
        )
        File.write(readme_file, readme.sub(compatibility_table[1], updated_table))
        puts "Updated Swagger UI compatibility table to #{semver} in #{readme_file}"
      end
    end
  end
end
