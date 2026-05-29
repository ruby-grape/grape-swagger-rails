# frozen_string_literal: true

require 'delegate'
require 'forwardable'

module ProcessExecuter
  # A simple delegator for Process::Status that adds a `timeout?` attribute
  #
  # @api public
  #
  class Status < SimpleDelegator
    extend Forwardable

    # Create a new Status object from a Process::Status and timeout flag
    #
    # @param status [Process::Status] the status to delegate to
    # @param timeout [Boolean] true if the process timed out
    # @param timeout_duration [Numeric, nil] The secs the command ran before being killed OR o or nil for no timeout
    #
    # @example
    #   status = Process.wait2(pid).last
    #   timeout = false
    #   ProcessExecuter::Status.new(status, timeout)
    #
    # @api public
    #
    def initialize(status, timeout, timeout_duration)
      super(status)
      @timeout = timeout
      @timeout_duration = timeout_duration
    end

    # The secs the command ran before being killed OR o or nil for no timeout
    # @example
    #   status.timeout_duration #=> 10
    # @return [Numeric, nil]
    attr_reader :timeout_duration

    # @!attribute [r] timeout?
    # True if the process timed out and was sent the SIGKILL signal
    # @example
    #   status = ProcessExecuter.spawn('sleep 10', timeout: 0.01)
    #   status.timeout? # => true
    # @return [Boolean]
    #
    def timeout? = @timeout

    # Overrides the default success? method to return nil if the process timed out
    #
    # This is because when a timeout occurs, Windows will still return true
    # @example
    #   status = ProcessExecuter.spawn('sleep 10', timeout: 0.01)
    #   status.success? # => nil
    # @return [Boolean, nil]
    #
    def success?
      return nil if timeout? # rubocop:disable Style/ReturnNilInPredicateMethodDefinition

      super
    end

    # Return a string representation of the status
    # @example
    #   status.to_s #=> "pid 70144 SIGKILL (signal 9) timed out after 10s"
    # @return [String]
    def to_s
      "#{super}#{timeout? ? " timed out after #{timeout_duration}s" : ''}"
    end
  end
end
