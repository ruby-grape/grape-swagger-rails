# frozen_string_literal: true

require 'pp'

module ProcessExecuter
  # Validate ProcessExecuter::Executer#spawn options and return Process.spawn options
  #
  # Valid options are those accepted by Process.spawn plus the following additions:
  #
  # * `:timeout`:
  #
  # @api public
  #
  class Options
    # :nocov:
    # SimpleCov on JRuby seems to hav a bug that causes hashes declared on multiple lines
    # to not be counted as covered.

    # These options should be passed to `Process.spawn`
    #
    # Additionally, any options whose key is an Integer or an IO object will
    # be passed to `Process.spawn`.
    #
    SPAWN_OPTIONS = %i[
      in out err unsetenv_others pgroup new_pgroup rlimit_resourcename umask
      close_others chdir
    ].freeze

    # These options are allowed by `ProcessExecuter.spawn` but should NOT be passed
    # to `Process.spawn`
    #
    NON_SPAWN_OPTIONS = %i[
      timeout
    ].freeze

    # Any `SPAWN_OPTIONS` set to `NOT_SET` will not be passed to `Process.spawn`
    #
    NOT_SET = :not_set

    # The default values for all options
    # @return [Hash]
    DEFAULTS = {
      in: NOT_SET,
      out: NOT_SET,
      err: NOT_SET,
      unsetenv_others: NOT_SET,
      pgroup: NOT_SET,
      new_pgroup: NOT_SET,
      rlimit_resourcename: NOT_SET,
      umask: NOT_SET,
      close_others: NOT_SET,
      chdir: NOT_SET,
      timeout: nil
    }.freeze

    # :nocov:

    # All options allowed by this class
    #
    ALL_OPTIONS = (SPAWN_OPTIONS + NON_SPAWN_OPTIONS).freeze

    # Create accessor functions for all options. Assumes that the options are stored
    # in a hash named `@options`
    #
    ALL_OPTIONS.each do |option|
      define_method(option) do
        @options[option]
      end
    end

    # Create a new Options object
    #
    # @example
    #   options = ProcessExecuter::Options.new(out: $stdout, err: $stderr, timeout: 10)
    #
    # @param options [Hash] Process.spawn options plus additional options listed below.
    #
    #   See [Process.spawn](https://ruby-doc.org/core/Process.html#method-c-spawn)
    #   for a list of valid options that can be passed to `Process.spawn`.
    #
    # @option options [Integer, Float, nil] :timeout
    #   Number of seconds to wait for the process to terminate. Any number
    #   may be used, including Floats to specify fractional seconds. A value of 0 or nil
    #   will allow the process to run indefinitely.
    #
    def initialize(**options)
      assert_no_unknown_options(options)
      @options = DEFAULTS.merge(options)
      assert_timeout_is_valid
    end

    # Returns the options to be passed to Process.spawn
    #
    # @example
    #   options = ProcessExecuter::Options.new(out: $stdout, err: $stderr, timeout: 10)
    #   options.spawn_options # => { out: $stdout, err: $stderr }
    #
    # @return [Hash]
    #
    def spawn_options
      {}.tap do |spawn_options|
        options.each do |option, value|
          spawn_options[option] = value if include_spawn_option?(option, value)
        end
      end
    end

    private

    # @!attribute [r]
    #
    # Options with values
    #
    # All options have values. If an option is not given in the initializer, it
    # will have the value `NOT_SET`.
    #
    # @return [Hash<Symbol, Object>]
    #
    # @api private
    #
    attr_reader :options

    # Determine if the options hash contains any unknown options
    # @param options [Hash] the hash of options
    # @return [void]
    # @raise [ArgumentError] if the options hash contains any unknown options
    # @api private
    def assert_no_unknown_options(options)
      unknown_options = options.keys.reject { |key| valid_option?(key) }
      raise ArgumentError, "Unknown options: #{unknown_options.join(', ')}" unless unknown_options.empty?
    end

    # Raise an error if timeout is not a real non-negative number
    # @return [void]
    # @raise [ArgumentError] if timeout is not a real non-negative number
    # @api private
    def assert_timeout_is_valid
      return if @options[:timeout].nil?
      return if @options[:timeout].is_a?(Numeric) && @options[:timeout].real? && !@options[:timeout].negative?

      raise ArgumentError, invalid_timeout_message
    end

    # The message to be used when raising an error for an invalid timeout
    # @return [String]
    # @api private
    def invalid_timeout_message
      "timeout must be nil or a real non-negative number but was #{options[:timeout].pretty_inspect}"
    end

    # Determine if the given option is a valid option
    # @param option [Symbol] the option to be tested
    # @return [Boolean] true if the given option is a valid option
    # @api private
    def valid_option?(option)
      ALL_OPTIONS.include?(option) || option.is_a?(Integer) || option.respond_to?(:fileno)
    end

    # Determine if the given option should be passed to `Process.spawn`
    # @param option [Symbol, Integer, IO] the option to be tested
    # @param value [Object] the value of the option
    # @return [Boolean] true if the given option should be passed to `Process.spawn`
    # @api private
    def include_spawn_option?(option, value)
      (option.is_a?(Integer) || option.is_a?(IO) || SPAWN_OPTIONS.include?(option)) && value != NOT_SET
    end
  end
end
