# frozen_string_literal: true

require 'process_executer/monitored_pipe'
require 'process_executer/options'
require 'process_executer/command'
require 'process_executer/status'

require 'logger'
require 'timeout'

# The `ProcessExecuter` module provides methods to execute subprocess commands
# with enhanced features such as output capture, timeout handling, and custom
# environment variables.
#
# Methods:
# * {run}: Executes a command and captures its output and status in a result object.
# * {spawn}: Executes a command and returns its exit status.
#
# Features:
# * Supports executing commands via a shell or directly.
# * Captures stdout and stderr to buffers, files, or custom objects.
# * Optionally enforces timeouts and terminates long-running commands.
# * Provides detailed status information, including success, failure, or timeout states.
#
# @api public
#
module ProcessExecuter
  # Execute the given command as a subprocess and return the exit status
  #
  # This is a convenience method that calls
  # [Process.spawn](https://docs.ruby-lang.org/en/3.3/Process.html#method-c-spawn)
  # and blocks until the command terminates.
  #
  # The command will be sent the SIGKILL signal if it does not terminate within
  # the specified timeout.
  #
  # @example
  #   status = ProcessExecuter.spawn('echo hello')
  #   status.exited? # => true
  #   status.success? # => true
  #   status.timeout? # => false
  #
  # @example with a timeout
  #   status = ProcessExecuter.spawn('sleep 10', timeout: 0.01)
  #   status.exited? # => false
  #   status.success? # => nil
  #   status.signaled? # => true
  #   status.termsig # => 9
  #   status.timeout? # => true
  #
  # @example capturing stdout to a string
  #   stdout = StringIO.new
  #   status = ProcessExecuter.spawn('echo hello', out: stdout)
  #   stdout.string # => "hello"
  #
  # @see https://ruby-doc.org/core-3.1.2/Kernel.html#method-i-spawn Kernel.spawn
  #   documentation for valid command and options
  #
  # @see ProcessExecuter::Options#initialize See ProcessExecuter::Options#initialize
  #   for options that may be specified
  #
  # @param command [Array<String>] The command to execute
  # @param options_hash [Hash] The options to use when executing the command
  #
  # @return [Process::Status] the exit status of the process
  #
  def self.spawn(*command, **options_hash)
    options = ProcessExecuter::Options.new(**options_hash)
    pid = Process.spawn(*command, **options.spawn_options)
    wait_for_process(pid, options)
  end

  # Execute the given command as a subprocess, blocking until it finishes
  #
  # Returns a result object which includes the process's status and output.
  #
  # Supports the same features as
  # [Process.spawn](https://docs.ruby-lang.org/en/3.3/Process.html#method-c-spawn).
  # In addition, it:
  #
  # 1. Blocks until the command exits
  # 2. Captures stdout and stderr to a buffer or file
  # 3. Optionally kills the command if it exceeds a timeout
  #
  # This method takes two forms:
  #
  # 1. The command is executed via a shell when the command is given as a single
  #    string:
  #
  #     `ProcessExecuter.run([env, ] command_line, options = {}) ->` {ProcessExecuter::Command::Result}
  #
  # 2. The command is executed directly (bypassing the shell) when the command and it
  #    arguments are given as an array of strings:
  #
  #     `ProcessExecuter.run([env, ] exe_path, *args, options = {}) ->` {ProcessExecuter::Command::Result}
  #
  # Optional argument `env` is a hash that affects ENV for the new process; see
  # [Execution
  # Environment](https://docs.ruby-lang.org/en/3.3/Process.html#module-Process-label-Execution+Environment).
  #
  # Argument `options` is a hash of options for the new process. See the options listed below.
  #
  # @example Run a command given as a single string (uses shell)
  #   # The command must be properly shell escaped when passed as a single string.
  #   command = 'echo "stdout: `pwd`"" && echo "stderr: $HOME" 1>&2'
  #   result = ProcessExecuter.run(command)
  #   result.success? #=> true
  #   result.stdout.string #=> "stdout: /Users/james/projects/main-branch/process_executer\n"
  #   result.stderr.string #=> "stderr: /Users/james\n"
  #
  # @example Run a command given as an array of strings (does not use shell)
  #   # The command and its args must be provided as separate strings in the array.
  #   # Shell expansions and redirections are not supported.
  #   command = ['git', 'clone', 'https://github.com/main-branch/process_executer']
  #   result = ProcessExecuter.run(*command)
  #   result.success? #=> true
  #   result.stdout.string #=> ""
  #   result.stderr.string #=> "Cloning into 'process_executer'...\n"
  #
  # @example Run a command with a timeout
  #   command = ['sleep', '1']
  #   result = ProcessExecuter.run(*command, timeout: 0.01)
  #   #=> raises ProcessExecuter::Command::TimeoutError which contains the command result
  #
  # @example Run a command which fails
  #   command = ['exit 1']
  #   result = ProcessExecuter.run(*command)
  #   #=> raises ProcessExecuter::Command::FailedError which contains the command result
  #
  # @example Run a command which exits due to an unhandled signal
  #   command = ['kill -9 $$']
  #   result = ProcessExecuter.run(*command)
  #   #=> raises ProcessExecuter::Command::SignaledError which contains the command result
  #
  # @example Return a result instead of raising an error when `raise_errors` is `false`
  #   # By setting `raise_errors` to `false`, exceptions will not be raised even
  #   # if the command fails.
  #   command = ['echo "Some error" 1>&2 && exit 1']
  #   result = ProcessExecuter.run(*command, raise_errors: false)
  #   # An error is not raised
  #   result.success? #=> false
  #   result.exitstatus #=> 1
  #   result.stdout.string #=> ""
  #   result.stderr.string #=> "Some error\n"
  #
  # @example Set environment variables
  #   env = { 'FOO' => 'foo', 'BAR' => 'bar' }
  #   command = 'echo "$FOO$BAR"'
  #   result = ProcessExecuter.run(env, *command)
  #   result.stdout.string #=> "foobar\n"
  #
  # @example Set environment variables when using a command array
  #   env = { 'GIT_DIR' => '/path/to/.git' }
  #   command = ['git', 'status']
  #   result = ProcessExecuter.run(env, *command)
  #   result.stdout.string #=> "On branch main\nYour branch is ..."
  #
  # @example Unset environment variables
  #   env = { 'GIT_DIR' => nil } # setting to nil unsets the variable in the environment
  #   command = ['git', 'status']
  #   result = ProcessExecuter.run(env, *command)
  #   result.stdout.string #=> "On branch main\nYour branch is ..."
  #
  # @example Reset existing environment variables and add new ones
  #   env = { 'PATH' => '/bin' }
  #   result = ProcessExecuter.run(env, 'echo "Home: $HOME" && echo "Path: $PATH"', unsetenv_others: true)
  #   result.stdout.string #=> "Home: \n/Path: /bin\n"
  #
  # @example Run command in a different directory
  #   command = ['pwd']
  #   result = ProcessExecuter.run(*command, chdir: '/tmp')
  #   result.stdout.string #=> "/tmp\n"
  #
  # @example Capture stdout and stderr into a single buffer
  #   command = ['echo "stdout" && echo "stderr" 1>&2']
  #   result = ProcessExecuter.run(*command, merge: true)
  #   result.stdout.string #=> "stdout\nstderr\n"
  #   result.stdout.object_id == result.stderr.object_id #=> true
  #
  # @example Capture to an explicit buffer
  #   out = StringIO.new
  #   err = StringIO.new
  #   command = ['echo "stdout" && echo "stderr" 1>&2']
  #   result = ProcessExecuter.run(*command, out: out, err: err)
  #   out.string #=> "stdout\n"
  #   err.string #=> "stderr\n"
  #   result.stdout.object_id == out.object_id #=> true
  #   result.stderr.object_id == err.object_id #=> true
  #
  # @example Capture to a file
  #   # Same technique can be used for stderr
  #   out = File.open('stdout.txt', 'w')
  #   command = ['echo "stdout" && echo "stderr" 1>&2']
  #   result = ProcessExecuter.run(*command, out: out, err: err)
  #   out.close
  #   File.read('stdout.txt') #=> "stdout\n"
  #   # stderr is still captured to a StringIO buffer internally
  #   result.stderr.string #=> "stderr\n"
  #
  # @example Capture to multiple writers (e.g. files, buffers, STDOUT, etc.)
  #   # Same technique can be used for stderr
  #   out_buffer = StringIO.new
  #   out_file = File.open('stdout.txt', 'w')
  #   command = ['echo "stdout" && echo "stderr" 1>&2']
  #   result = ProcessExecuter.run(*command, out: [out_buffer, out_file])
  #   # You must manage closing resources you create yourself
  #   out_file.close
  #   out_buffer.string #=> "stdout\n"
  #   File.read('stdout.txt') #=> "stdout\n"
  #
  # @param command [Array<String>] The command to run
  #
  #   If the first element of command is a Hash, it is added to the ENV of
  #   the new process. See [Execution Environment](https://ruby-doc.org/3.3.6/Process.html#module-Process-label-Execution+Environment)
  #   for more details. The env hash is then removed from the command array.
  #
  #   If the first and only (remaining) command element is a string, it is passed to
  #   a subshell if it begins with a shell reserved word, contains special built-ins,
  #   or includes shell metacharacters.
  #
  #   Care must be taken to properly escape shell metacharacters in the command string.
  #
  #   Otherwise, the command is run bypassing the shell. When bypassing the shell, shell expansions
  #   and redirections are not supported.
  #
  # @param logger [Logger] The logger to use
  # @param options_hash [Hash] Additional options
  # @option options_hash [Numeric] :timeout The maximum seconds to wait for the command to complete
  #
  #     If timeout is zero or nil, the command will not time out. If the command
  #     times out, it is killed via a SIGKILL signal and {ProcessExecuter::Command::TimeoutError} is raised.
  #
  #     If the command does not exit when receiving the SIGKILL signal, this method may hang indefinitely.
  #
  # @option options_hash [#write] :out (nil) The object to write stdout to
  # @option options_hash [#write] :err (nil) The object to write stderr to
  # @option options_hash [Boolean] :merge (false) If true, stdout and stderr are written to the same capture buffer
  # @option options_hash [Boolean] :raise_errors (true) Raise an exception if the command fails
  # @option options_hash [Boolean] :unsetenv_others (false) If true, unset all environment variables before
  #   applying the new ones
  # @option options_hash [true, Integer, nil] :pgroup (nil) true or 0: new process group; non-zero: join
  #   the group, nil: existing group
  # @option options_hash [Boolean] :new_pgroup (nil) Create a new process group (Windows only)
  # @option options_hash [Integer] :rlimit_resource_name (nil) Set resource limits (see Process.setrlimit)
  # @option options_hash [Integer] :umask (nil) Set the umask (see File.umask)
  # @option options_hash [Boolean] :close_others (false) If true, close non-standard file descriptors
  # @option options_hash [String] :chdir (nil) The directory to run the command in
  #
  # @raise [ProcessExecuter::Command::FailedError] if the command returned a non-zero exit status
  # @raise [ProcessExecuter::Command::SignaledError] if the command exited because of an unhandled signal
  # @raise [ProcessExecuter::Command::TimeoutError] if the command timed out
  # @raise [ProcessExecuter::Command::ProcessIOError] if an exception was raised while collecting subprocess output
  #
  # @return [ProcessExecuter::Command::Result] A result object containing the process status and captured output
  #
  def self.run(*command, logger: Logger.new(nil), **options_hash)
    ProcessExecuter::Command::Runner.new(logger).call(*command, **options_hash)
  end

  # Wait for process to terminate
  #
  # If a timeout is specified in options, terminate the process after options.timeout seconds.
  #
  # @param pid [Integer] the process ID
  # @param options [ProcessExecuter::Options] the options used
  #
  # @return [ProcessExecuter::Status] the process status including Process::Status attributes and a timeout flag
  #
  # @api private
  #
  private_class_method def self.wait_for_process(pid, options)
    Timeout.timeout(options.timeout) do
      ProcessExecuter::Status.new(Process.wait2(pid).last, false, options.timeout)
    end
  rescue Timeout::Error
    Process.kill('KILL', pid)
    ProcessExecuter::Status.new(Process.wait2(pid).last, true, options.timeout)
  end
end
