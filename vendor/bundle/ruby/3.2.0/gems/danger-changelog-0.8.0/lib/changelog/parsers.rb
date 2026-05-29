require 'changelog/parsers/base'
require 'changelog/parsers/validation_result'
require 'changelog/parsers/intridea_format'
require 'changelog/parsers/keep_a_changelog'

module Danger
  module Changelog
    module Parsers
      FORMATS = { intridea: IntrideaFormat, keep_a_changelog: KeepAChangelog }.freeze

      class << self
        def default_format
          :intridea
        end

        def valid?(format)
          FORMATS.keys.map(&:to_s).include?(format.to_s)
        end

        def lookup(format)
          FORMATS
            .fetch(format, IntrideaFormat)
            .new
        end
      end
    end
  end
end
