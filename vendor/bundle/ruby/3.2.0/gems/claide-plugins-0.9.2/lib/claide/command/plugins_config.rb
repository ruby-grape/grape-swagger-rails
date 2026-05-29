require 'claide'

module CLAide
  module Plugins
    class Configuration
      # name of the plugin
      attr_accessor :name

      # prefix to use when searching for gems to load at runtime
      attr_accessor :plugin_prefix

      # url for JSON file that holds list of plugins to show when searching
      attr_accessor :plugin_list_url

      # url for repo that holds template to use when creating a new plugin
      attr_accessor :plugin_template_url

      def initialize(name = 'default name',
                     plugin_prefix = 'claide',
                     plugin_list_url = 'https://github.com/cocoapods/claide-plugins/something.json',
                     plugin_template_url = 'https://github.com/cocoapods/claide-plugins-template')
        @name = name
        @plugin_prefix = plugin_prefix
        @plugin_list_url = plugin_list_url
        @plugin_template_url = plugin_template_url
      end
    end

    class << self
      attr_accessor :config
    end
    # set a default configuration that will work with claide-plugins
    self.config = Configuration.new
  end
end
