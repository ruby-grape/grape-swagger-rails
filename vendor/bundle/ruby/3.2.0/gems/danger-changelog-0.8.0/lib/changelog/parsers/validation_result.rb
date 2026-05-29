module Danger
  module Changelog
    module Parsers
      class ValidationResult
        def initialize
          @errors = []
        end

        attr_reader :errors

        def valid?
          errors.empty?
        end

        def invalid?
          !valid?
        end

        def error!(message)
          errors << message
        end

        def to_s
          return nil if valid?

          errors.join(', ')
        end
      end
    end
  end
end
