# frozen_string_literal: true

require_relative 'errors'
require_relative 'result'

module ProcessExecuter
  module Command
    # The `Runner` class executes subprocess commands and captures their status and output.
    #
    # It does the following:
    # - Run commands (`call`) with options for capturing output, handling timeouts, and merging stdout/stderr.
    # - Process command results, including logging and error handling.
    # - Raise detailed exceptions for common command failures, such as timeouts or subprocess errors.
    #
    # This class is used internally by {ProcessExecuter.run}.
    #
    # @api public
    #
    class Runner
      # Create a new RunCommand instance
      #
      # @example
      #   runner = Runner.new()
      #   status = runner.call('echo', 'hello')
      #
      # @param logger [Logger] The logger to use. Defaults to a no-op logger if nil.
      #
      def initialize(logger)
        @logger = logger || Logger.new(nil)
      end

      # The logger to use
      # @example
      #   runner.logger #=> #<Logger:0x00007f9b1b8b3d20>
      # @return [Logger]
      attr_reader :logger

      # rubocop:disable Metrics/ParameterLists

      # Run a command and return the status including stdout and stderr output
      #
      # @example
      #   command = %w[git status]
      #   status = run(command)
      #   status.success? # => true
      #   status.exitstatus # => 0
      #   status.out # => "On branch master\nnothing to commit, working tree clean\n"
      #   status.err # => ""
      #
      # @param command [Array<String>] The command to run
      # @param out [#write] The object to which stdout is written
      # @param err [#write] The object to which stderr is written
      # @param merge [Boolean] Write both stdout and stderr into the buffer for stdout
      # @param raise_errors [Boolean] Raise an exception if the command fails
      # @param options_hash [Hash] Additional options to pass to Process.spawn
      #
      #   See {ProcessExecuter.run} for a full list of options.
      #
      # @return [ProcessExecuter::Command::Result] The status of the subprocess and captured stdout and stderr output
      #
      def call(*command, out: nil, err: nil, merge: false, raise_errors: true, **options_hash)
        out ||= StringIO.new
        err ||= (merge ? out : StringIO.new)

        status = spawn(command, out:, err:, **options_hash)

        process_result(command, status, out, err, options_hash[:timeout], raise_errors)
      end

      # rubocop:enable Metrics/ParameterLists

      private

      # Wrap the output buffers in pipes and then execute the command
      #
      # @param command [Array<String>] The command to execute
      # @param out [#write] The object to which stdout is written
      # @param err [#write] The object to which stderr is written
      # @param options_hash [Hash] Additional options to pass to Process.spawn
      #
      #   See {ProcessExecuter.run} for a full list of options.
      #
      # @raise [ProcessExecuter::Command::ProcessIOError] If an exception was raised while collecting subprocess output
      # @raise [ProcessExecuter::Command::TimeoutError] If the command times out
      #
      # @return [ProcessExecuter::Status] The status of the completed subprocess
      #
      # @api private
      #
      def spawn(command, out:, err:, **options_hash)
        out = [out] unless out.is_a?(Array)
        err = [err] unless err.is_a?(Array)
        out_pipe = ProcessExecuter::MonitoredPipe.new(*out)
        err_pipe = ProcessExecuter::MonitoredPipe.new(*err)
        ProcessExecuter.spawn(*command, out: out_pipe, err: err_pipe, **options_hash)
      ensure
        out_pipe.close
        err_pipe.close
        raise_pipe_error(command, :stdout, out_pipe) if out_pipe.exception
        raise_pipe_error(command, :stderr, err_pipe) if err_pipe.exception
      end

      # rubocop:disable Metrics/ParameterLists

      # Process the result of the command and return a ProcessExecuter::Command::Result
      #
      # Log the command and result, and raise an error if the command failed.
      #
      # @param command [Array<String>] The git command that was executed
      # @param status [Process::Status] The status of the completed subprocess
      # @param out [#write] The object that stdout was written to
      # @param err [#write] The object that stderr was written to
      # @param timeout [Numeric, nil] The maximum seconds to wait for the command to complete
      # @param raise_errors [Boolean] Raise an exception if the command fails
      #
      # @return [ProcessExecuter::Command::Result] The status of the subprocess and captured stdout and stderr output
      #
      # @raise [ProcessExecuter::Command::FailedError] If the command failed
      # @raise [ProcessExecuter::Command::SignaledError] If the command was signaled
      # @raise [ProcessExecuter::Command::TimeoutError] If the command times out
      # @raise [ProcessExecuter::Command::ProcessIOError] If an exception was raised while collecting subprocess output
      #
      # @api private
      #
      def process_result(command, status, out, err, timeout, raise_errors)
        Result.new(command, status, out, err).tap do |result|
          log_result(result)

          if raise_errors
            raise TimeoutError.new(result, timeout) if status.timeout?
            raise SignaledError, result if status.signaled?
            raise FailedError, result unless status.success?
          end
        end
      end

      # rubocop:enable Metrics/ParameterLists

      # Log the command and result of the subprocess
      # @param result [ProcessExecuter::Command::Result] the result of the command including
      #   the command, status, stdout, and stderr
      # @return [void]
      # @api private
      def log_result(result)
        logger.info { "#{result.command} exited with status #{result}" }
        logger.debug { "stdout:\n#{result.stdout_to_s.inspect}\nstderr:\n#{result.stderr_to_s.inspect}" }
      end

      # Raise an error when there was exception while collecting the subprocess output
      #
      # @param command [Array<String>] The command that was executed
      # @param pipe_name [Symbol] The name of the pipe that raised the exception
      # @param pipe [ProcessExecuter::MonitoredPipe] The pipe that raised the exception
      #
      # @raise [ProcessExecuter::Command::ProcessIOError]
      #
      # @return [void] This method always raises an error
      #
      # @api private
      #
      def raise_pipe_error(command, pipe_name, pipe)
        error = ProcessExecuter::Command::ProcessIOError.new("Pipe Exception for #{command}: #{pipe_name}")
        raise(error, cause: pipe.exception)
      end
    end
  end
end
