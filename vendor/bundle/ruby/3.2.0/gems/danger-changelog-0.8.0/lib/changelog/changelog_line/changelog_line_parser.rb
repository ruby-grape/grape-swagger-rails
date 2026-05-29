require 'changelog/changelog_line/changelog_entry_line'
require 'changelog/changelog_line/changelog_header_line'
require 'changelog/changelog_line/changelog_placeholder_line'

module Danger
  module Changelog
    # A parser of the CHANGELOG.md lines
    class ChangelogLineParser
      # Returns an instance of Changelog::ChangelogLine class based on the given line
      def self.parse(line)
        changelog_line_class = available_changelog_lines.find do |changelog_line|
          changelog_line.validates_as_changelog_line?(line)
        end
        return nil unless changelog_line_class

        changelog_line_class.new(line)
      end

      def self.available_changelog_lines
        # Order is important
        [ChangelogPlaceholderLine, ChangelogEntryLine, ChangelogHeaderLine]
      end

      private_class_method :available_changelog_lines
    end
  end
end
