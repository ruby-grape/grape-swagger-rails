require 'claide/command/plugins_helper'
require 'claide/command/gem_helper'
require 'claide/command/template_runner'

module CLAide
  class Command
    class Plugins
      # The create subcommand. Used to create a new plugin using either the
      # default template (CocoaPods/cocoapods-plugin-template) or a custom
      # template
      #
      class Create < Plugins
        self.summary = 'Creates a new plugin'
        def self.description
          <<-DESC
                Creates a scaffold for the development of a new plugin
                named `NAME` according to the best practices.

                If a `TEMPLATE_URL`, pointing to a git repo containing a
                compatible template, is specified, it will be used
                in place of the default one.
          DESC
        end

        self.arguments = [
          CLAide::Argument.new('NAME', true),
          CLAide::Argument.new('TEMPLATE_URL', false),
        ]

        def initialize(argv)
          @name = argv.shift_argument
          prefix = CLAide::Plugins.config.plugin_prefix + '-'
          unless @name.nil? || @name.empty? || @name.start_with?(prefix)
            @name = prefix + @name.dup
          end
          @template_url = argv.shift_argument
          super
        end

        def validate!
          super
          if @name.nil? || @name.empty?
            help! 'A name for the plugin is required.'
          end

          help! 'The plugin name cannot contain spaces.' if @name.match(/\s/)
        end

        def run
          runner = TemplateRunner.new @name, @template_url
          runner.clone_template
          runner.configure_template
          show_reminder
        end

        #----------------------------------------#

        private

        # Shows a reminder to the plugin author to make a Pull Request
        # in order to update plugins.json once the plugin is released
        #
        def show_reminder
          repo = PluginsHelper.plugins_raw_url
          UI.notice "Don't forget to create a Pull Request on #{repo}\n" \
            ' to add your plugin to the plugins.json file once it is released!'
        end
      end
    end
  end
end
