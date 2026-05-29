# frozen_string_literal: true

require 'delegate'

module ProcessExecuter
  module Command
    # A wrapper around {ProcessExecuter::Status} which adds captured command output
    #
    # This class is used to represent the result of a subprocess execution, combining
    # the process status with the captured output for easier access and manipulation.
    #
    # Features:
    # * Provides access to the process's status, stdout, and stderr.
    # * Allows conversion of stdout and stderr buffers to strings.
    #
    # @example Create a Result object
    #   status = ProcessExecuter.spawn(*command, timeout:, out:, err:)
    #   result = ProcessExecuter::Command::Result.new(command, status, out_buffer.string, err_buffer.string)
    #
    # @api public
    #
    class Result < SimpleDelegator
      # Create a new Result object
      # @example
      #   status = ProcessExecuter.spawn(*command, timeout:, out:, err:)
      #   Result.new(command, status, out_buffer.string, err_buffer.string)
      # @param command [Array<String>] The command that was executed
      # @param status [ProcessExecuter::Status] The status of the process
      # @param stdout [String] The stdout output from the process
      # @param stderr [String] The stderr output from the process
      def initialize(command, status, stdout, stderr)
        super(status)
        @command = command
        @stdout = stdout
        @stderr = stderr
      end

      # The command that was run
      # @example
      #   result.command #=> %w[git status]
      # @return [Array<String>]
      attr_reader :command

      # The captured stdout output from the process
      # @example
      #   result.stdout #=> "On branch master\nnothing to commit, working tree clean\n"
      # @return [String]
      attr_reader :stdout

      # The captured stderr output from the process
      # @example
      #   result.stderr #=> "ERROR: file not found"
      # @return [String]
      attr_reader :stderr

      # Return the stdout output as a string
      # @example When stdout is a StringIO containing "Hello World"
      #   result.stdout_to_s #=> "Hello World"
      # @example When stdout is a File object
      #   result.stdout_to_s #=> #<File:/tmp/output.txt>
      # @return [String, Object] Returns a String if stdout is a StringIO; otherwise, returns the stdout object
      def stdout_to_s
        stdout.respond_to?(:string) ? stdout.string : stdout
      end

      # Return the stderr output as a string
      # @example When stderr is a StringIO containing "Hello World"
      #   result.stderr_to_s #=> "Hello World"
      # @example When stderr is a File object
      #   result.stderr_to_s #=> #<File:/tmp/output.txt>
      # @return [String, Object] Returns a String if stderr is a StringIO; otherwise, returns the stderr object
      def stderr_to_s
        stderr.respond_to?(:string) ? stderr.string : stderr
      end
    end
  end
end
