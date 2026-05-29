module Danger
  module Changelog
    # A CHANGELOG.md line represents the "Your contribution here".
    class ChangelogPlaceholderLine < ChangelogLine
      def valid?
        ChangelogPlaceholderLine.validates_as_changelog_line?(line)
      end

      def self.validates_as_changelog_line?(line)
        return true if line == Danger::Changelog.config.placeholder_line

        false
      end
    end
  end
end
