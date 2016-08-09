require 'git'

namespace :swagger_ui do
  namespace :dist do
    desc 'Update Swagger-UI from wordnik/swagger-ui.'
    task :update do
      Dir.mktmpdir 'swagger-ui' do |dir|
        puts "Cloning into #{dir} ..."
        # clone wordnik/swagger-ui
        Git.clone 'git@github.com:wordnik/swagger-ui.git', 'swagger-ui', path: dir, depth: 0
        # prune local files
        root = File.expand_path '../../..', __FILE__
        puts "Removing files from #{root} ..."
        repo = Git.open root
        # Javascripts
        puts 'Copying Javascripts ...'
        FileUtils.rm_r "#{root}/app/assets/javascripts/grape_swagger_rails"
        FileUtils.cp_r "#{dir}/swagger-ui/dist/lib", "#{root}/app/assets/javascripts"
        FileUtils.mv "#{root}/app/assets/javascripts/lib", "#{root}/app/assets/javascripts/grape_swagger_rails"
        FileUtils.cp_r Dir.glob("#{dir}/swagger-ui/dist/swagger-ui.min.js"), "#{root}/app/assets/javascripts/grape_swagger_rails"
        FileUtils.cp Dir.glob("#{root}/lib/javascripts/*.js"), "#{root}/app/assets/javascripts/grape_swagger_rails"
        # Generate application.js
        JAVASCRIPT_FILES = [
          'jquery-1.8.0.min.js',
          'jquery.slideto.min.js',
          'jquery.wiggle.min.js',
          'jquery.ba-bbq.min.js',
          'handlebars-2.0.0.js',
          'marked.js',
          'lodash.min.js',
          'backbone-min.js',
          'swagger-ui.min.js',
          'highlight.9.1.0.pack.js',
          'js-yaml.min.js',
          'jsoneditor.min.js',
          'object-assign-pollyfill.js',
          'swagger-oauth.js',
          'base64.js'
        ]
        javascript_files = Dir["#{root}/app/assets/javascripts/grape_swagger_rails/*.js"].map { |f|
          f.split('/').last
        } - ['application.js']
        (javascript_files - JAVASCRIPT_FILES).each do |filename|
          puts "WARNING: add #{filename} to swagger_ui.rake"
        end
        (JAVASCRIPT_FILES - javascript_files).each do |filename|
          puts "WARNING: remove #{filename} from swagger_ui.rake"
        end
        File.open "#{root}/app/assets/javascripts/grape_swagger_rails/application.js", 'w+' do |file|
          JAVASCRIPT_FILES.each do |filename|
            file.write "//= require ./#{File.basename(filename, '.*')}\n"
          end
        end
        # Stylesheets
        puts 'Copying Stylesheets ...'
        repo.remove 'app/assets/stylesheets/grape_swagger_rails', recursive: true
        FileUtils.mkdir_p "#{root}/app/assets/stylesheets/grape_swagger_rails"
        FileUtils.cp_r Dir.glob("#{dir}/swagger-ui/dist/css/**/*"), "#{root}/app/assets/stylesheets/grape_swagger_rails"
        repo.add 'app/assets/stylesheets/grape_swagger_rails'
        # Generate application.js
        CSS_FILES = [
          'reset.css',
          'screen.css'
        ]
        css_files = Dir["#{root}/app/assets/stylesheets/grape_swagger_rails/*.css"].map { |f|
          f.split('/').last
        } - ['application.css']
        (css_files - CSS_FILES).each do |filename|
          puts "WARNING: add #{filename} to swagger_ui.rake"
        end
        (CSS_FILES - css_files).each do |filename|
          puts "WARNING: remove #{filename} from swagger_ui.rake"
        end
        # rewrite screen.css into screen.css.erb with dynamic image paths
        File.open "#{root}/app/assets/stylesheets/grape_swagger_rails/screen.css.erb", 'w+' do |file|
          contents = File.read "#{root}/app/assets/stylesheets/grape_swagger_rails/screen.css"
          contents.gsub! /url\((\'*).*\/(?<filename>[\w\.]*)(\'*)\)/ do |_match|
            "url(<%= image_path('grape_swagger_rails/#{$LAST_MATCH_INFO[:filename]}') %>)"
          end
          file.write contents
          FileUtils.rm "#{root}/app/assets/stylesheets/grape_swagger_rails/screen.css"
        end
        File.open "#{root}/app/assets/stylesheets/grape_swagger_rails/application.css", 'w+' do |file|
          file.write "/*\n"
          CSS_FILES.each do |filename|
            file.write "*= require ./#{File.basename(filename, '.*')}\n"
          end
          file.write "*= require_self\n"
          file.write "*/\n"
        end
        # Images
        puts 'Copying Images ...'
        repo.remove 'app/assets/images/grape_swagger_rails', recursive: true
        FileUtils.mkdir_p "#{root}/app/assets/images/grape_swagger_rails"
        FileUtils.cp_r Dir.glob("#{dir}/swagger-ui/dist/images/**/*"), "#{root}/app/assets/images/grape_swagger_rails"
        repo.add 'app/assets'
      end
    end
  end
end
