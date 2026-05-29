# frozen_string_literal: true

# rubocop:disable Layout/LineLength

module ProcessExecuter
  module Command
    # Base class for all ProcessExecuter::Command errors
    #
    # It is recommended to rescue `ProcessExecuter::Command::Error` to catch any
    # runtime error raised by this gem unless you need more specific error handling.
    #
    # Custom errors are arranged in the following class hierarchy:
    #
    # ```text
    # ::StandardError
    #   └─> Error
    #       ├─> CommandError
    #       │   ├─> FailedError
    #       │   └─> SignaledError
    #       │       └─> TimeoutError
    #       └─> ProcessIOError
    # ```
    #
    # | Error Class | Description |
    # | --- | --- |
    # | `Error` | This catch-all error serves as the base class for other custom errors. |
    # | `CommandError` | A subclass of this error is raised when there is a problem executing a command. |
    # | `FailedError` | Raised when the command exits with a non-zero status code. |
    # | `SignaledError` | Raised when the command is terminated as a result of receiving a signal. This could happen if the process is forcibly terminated or if there is a serious system error. |
    # | `TimeoutError` | This is a specific type of `SignaledError` that is raised when the command times out and is killed via the SIGKILL signal. Raised when the operation takes longer than the specified timeout duration (if provided). |
    # | `ProcessIOError` | Raised when an error was encountered reading or writing to the command's subprocess. |
    #
    # @example Rescuing any error
    #   begin
    #     ProcessExecuter.run_command('git', 'status')
    #   rescue ProcessExecuter::Command::Error => e
    #     puts "An error occurred: #{e.message}"
    #   end
    #
    # @example Rescuing a timeout error
    #   begin
    #     timeout_duration = 0.1 # seconds
    #     ProcessExecuter.run_command('sleep', '1', timeout: timeout_duration)
    #   rescue ProcessExecuter::TimeoutError => e # Catch the more specific error first!
    #     puts "Command took too long and timed out: #{e}"
    #   rescue ProcessExecuter::Error => e
    #     puts "Some other error occured: #{e}"
    #   end
    #
    # @api public
    #
    class Error < ::StandardError; end

    # Raised when a command fails or exits because of an uncaught signal
    #
    # The command executed, status, stdout, and stderr are available from this
    # object.
    #
    # The Gem will raise a more specific error for each type of failure:
    #
    # * {FailedError}: when the command exits with a non-zero status
    # * {SignaledError}: when the command exits because of an uncaught signal
    # * {TimeoutError}: when the command times out
    #
    # @api public
    #
    class CommandError < ProcessExecuter::Command::Error
      # Create a CommandError object
      #
      # @example
      #   `exit 1` # set $? appropriately for this example
      #   result = ProcessExecuter::Command::Result.new(%w[git status], $?, 'stdout', 'stderr')
      #   error = ProcessExecuter::Command::CommandError.new(result)
      #   error.to_s #=> '["git", "status"], status: pid 89784 exit 1, stderr: "stderr"'
      #
      # @param result [Result] The result of the command including the command,
      #   status, stdout, and stderr
      #
      def initialize(result)
        @result = result
        super(error_message)
      end

      # The human readable representation of this error
      #
      # @example
      #   error.error_message #=> '["git", "status"], status: pid 89784 exit 1, stderr: "stderr"'
      #
      # @return [String]
      #
      def error_message
        "#{result.command}, status: #{result}, stderr: #{result.stderr_to_s.inspect}"
      end

      # @attribute [r] result
      #
      # The result of the command including the command, its status and its output
      #
      # @example
      #   error.result #=> #<ProcessExecuter::Command::Result:0x00007f9b1b8b3d20>
      #
      # @return [Result]
      #
      attr_reader :result
    end

    # Raised when the command returns a non-zero exitstatus
    #
    # @api public
    #
    class FailedError < ProcessExecuter::Command::CommandError; end

    # Raised when the command exits because of an uncaught signal
    #
    # @api public
    #
    class SignaledError < ProcessExecuter::Command::CommandError; end

    # Raised when the command takes longer than the configured timeout
    #
    # @example
    #   result.status.timeout? #=> true
    #
    # @api public
    #
    class TimeoutError < ProcessExecuter::Command::SignaledError
      # Create a TimeoutError object
      #
      # @example
      #   command = %w[sleep 10]
      #   timeout_duration = 1
      #   status = ProcessExecuter.spawn(*command, timeout: timeout_duration)
      #   result = Result.new(command, status, 'stdout', 'err output')
      #   error = TimeoutError.new(result, timeout_duration)
      #   error.error_message
      #     #=> '["sleep", "10"], status: pid 70144 SIGKILL (signal 9), stderr: "err output", timed out after 1s'
      #
      # @param result [Result] The result of the command including the git command,
      #   status, stdout, and stderr
      #
      # @param timeout_duration [Numeric] The duration the subprocess was allowed
      #   to run before being terminated
      #
      def initialize(result, timeout_duration)
        @timeout_duration = timeout_duration
        super(result)
      end

      # The amount of time the subprocess was allowed to run before being killed
      #
      # @example
      #   `kill -9 $$` # set $? appropriately for this example
      #   result = Result.new(%w[git status], $?, '', "killed")
      #   error = TimeoutError.new(result, 10)
      #   error.timeout_duration #=> 10
      #
      # @return [Numeric]
      #
      attr_reader :timeout_duration
    end

    # Raised when the output of a command can not be read
    #
    # @api public
    #
    class ProcessIOError < ProcessExecuter::Command::Error; end
  end
end

# rubocop:enable Layout/LineLength
