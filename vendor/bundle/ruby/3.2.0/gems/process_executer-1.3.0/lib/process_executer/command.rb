# frozen_string_literal: true

module ProcessExecuter
  # This module contains classes for implementing ProcessExecuter.run_command
  module Command; end
end

require_relative 'command/errors'
require_relative 'command/result'
require_relative 'command/runner'

# Runs a command and returns the result
