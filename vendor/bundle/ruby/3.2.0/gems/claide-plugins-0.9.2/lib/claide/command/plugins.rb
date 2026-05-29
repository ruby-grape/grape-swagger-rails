require 'rest'
require 'json'
require 'cork'
require 'claide'
require 'claide/command/plugins_config'

UI = Cork::Board.new

module CLAide
  module Plugins
    class << self
      attr_accessor :config
    end
    # set a default configuration that will work with claide-plugins
    self.config = Configuration.new
  end

  # Indicates a runtime error **not** caused by a bug.
  #
  class PlainInformative < StandardError; end

  # Indicates a user error.
  #
  class Informative < PlainInformative; end

  class Command
    # The claide plugins command.
    #
    class Plugins < Command
      require 'claide/command/plugins/list'
      require 'claide/command/plugins/search'
      require 'claide/command/plugins/create'

      self.abstract_command = true
      self.default_subcommand = 'list'

      self.summary = 'Show available plugins'
      self.description = <<-DESC
        Lists or searches the available plugins
        and show if you have them installed or not.

        Also allows you to quickly create a new
        plugin using a provided template.
      DESC
    end
  end
end
