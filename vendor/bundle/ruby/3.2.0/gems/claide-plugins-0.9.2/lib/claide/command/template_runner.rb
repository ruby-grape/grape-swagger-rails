require 'claide/command/plugins_helper'
require 'claide/executable'

module CLAide
  class TemplateRunner
    extend CLAide::Executable
    executable :git

    def initialize(name, template_url)
      @name = name
      @template_url = template_url
    end

    # Clones the template from the remote in the working directory using
    # the name of the plugin.
    #
    # @return [void]
    #
    def clone_template
      UI.section("-> Creating `#{@name}` plugin") do
        UI.notice "using template '#{template_repo_url}'"
        command = ['clone', template_repo_url, @name]
        git! command
      end
    end

    # Runs the template configuration utilities.
    #
    # @return [void]
    #
    def configure_template
      UI.section('-> Configuring template') do
        Dir.chdir(@name) do
          if File.file? 'configure'
            system "./configure #{@name}"
          else
            UI.warn 'Template does not have a configure file.'
          end
        end
      end
    end

    # Checks if a template URL is given else returns the Plugins.config URL
    #
    # @return String
    #
    def template_repo_url
      @template_url || CLAide::Plugins.config.plugin_template_url
    end
  end
end
