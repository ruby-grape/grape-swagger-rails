module Danger
  module Changelog
    # An abstract CHANGELOG.md line.
    class ChangelogLine
      NON_DELIMITERS = /[^(){}\[\]]*/.freeze
      PAIRED = /\(#{NON_DELIMITERS}\)|\{#{NON_DELIMITERS}\}|\[#{NON_DELIMITERS}\]/.freeze
      DELIMITER = /[(){}\[\]]/.freeze

      attr_accessor :line, :validation_result

      def initialize(line)
        self.line = line
        self.validation_result = nil
      end

      # Match the line with the validation rules
      def valid?
        raise 'ChangelogLine subclass must implement the valid? method'
      end

      # Match the line with the validation rules opposite to valid?
      def invalid?
        !valid?
      end

      # Match the given line if it potentially represents the specific changelog line
      def self.validates_as_changelog_line?(_line)
        abort "You need to include a function for #{self} for validates_as_changelog_line?"
      end

      # https://stackoverflow.com/questions/25979364/ruby-regex-for-matching-brackets
      def balanced?(line_with_parens)
        line_with_parens = line_with_parens.dup
        line_with_parens.gsub!(PAIRED, ''.freeze) while line_with_parens =~ PAIRED
        line_with_parens !~ DELIMITER
      end
    end
  end
end
