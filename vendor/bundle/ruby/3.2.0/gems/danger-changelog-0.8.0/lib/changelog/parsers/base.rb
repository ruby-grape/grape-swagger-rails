module Danger
  module Changelog
    module Parsers
      class Base
        def initialize(listeners = [])
          @listeners = listeners
        end

        attr_reader :listeners

        def add_listener(changelog)
          listeners << changelog
        end

        private

        def notify_of_bad_line(message, detail = nil)
          listeners.each { |changelog| changelog.add_bad_line(message, detail) }
        end

        def notify_of_global_failure(message)
          listeners.each { |changelog| changelog.add_global_failure(message) }
        end
      end
    end
  end
end
