require 'changelog/changelog_line/changelog_line'

module Danger
  module Changelog
    # A CHANGELOG.md line represents the change entry.
    class ChangelogEntryLine < ChangelogLine
      def valid?
        return validation_result.valid? if validation_result

        @validation_result = Parsers::ValidationResult.new

        validation_result.error! 'too many parenthesis' unless balanced?(line)
        return false if validation_result.invalid?

        return true if line =~ %r{^\*\s[`[:upper:]].*[^.,] - \[@[\w\d\-_]+\]\(https://github\.com/.*[\w\d\-_]+\).$}
        return true if line =~ %r{^\*\s\[\#\d+\]\(https://github\.com/.*\d+\): [`[:upper:]].*[^.,] - \[@[\w\d\-_]+\]\(https://github\.com/.*[\w\d\-_]+\).$}

        validation_result.error! 'does not start with a star' unless ChangelogEntryLine.starts_with_star?(line)
        validation_result.error! 'does not include a pull request link' unless ChangelogEntryLine.with_pr_link?(line)
        validation_result.error! 'does not have a description' unless ChangelogEntryLine.with_changelog_description?(line)
        validation_result.error! 'does not include an author link' unless ChangelogEntryLine.with_author_link?(line)
        validation_result.error! 'has an extra trailing space' if ChangelogEntryLine.ends_with_space?(line)
        validation_result.error! 'is missing a period at the end of the line' unless ChangelogEntryLine.ends_with_period?(line)
        validation_result.error! 'has an extra period or comma at the end of the description' if
          line =~ %r{^\*\s[`[:upper:]].*[.,] - \[@[\w\d\-_]+\]\(https://github\.com/.*[\w\d\-_]+\).$} ||
          line =~ %r{^\*\s\[\#\d+\]\(https://github\.com/.*\d+\): [`[:upper:]].*[.,] - \[@[\w\d\-_]+\]\(https://github\.com/.*[\w\d\-_]+\).$}

        false
      end

      def self.validates_as_changelog_line?(line)
        matched_rules_count = 0
        matched_rules_count += 1 if starts_with_star?(line)
        matched_rules_count += 1 if with_pr_link?(line)
        matched_rules_count += 1 if with_changelog_description?(line)
        matched_rules_count += 1 if with_author_link?(line)
        matched_rules_count >= 2
      end

      # provide an example of a CHANGELOG line based on a commit message
      def self.example(github)
        pr_number = github.pr_json['number']
        pr_url = github.pr_json['html_url']
        pr_title = github.pr_title
                         .sub(/[?.!,;]?$/, '')
                         .capitalize
        pr_author = github.pr_author
        pr_author_url = "https://github.com/#{github.pr_author}"
        "* [##{pr_number}](#{pr_url}): #{pr_title} - [@#{pr_author}](#{pr_author_url})."
      end

      # checks whether line starts with *
      def self.starts_with_star?(line)
        return true if line =~ /^\*\s/

        false
      end

      # checks whether line ends with a space
      def self.ends_with_space?(line)
        return true if line =~ /[[:blank:]]\n$/

        false
      end

      # checks whether line ends with a period
      def self.ends_with_period?(line)
        return true if line =~ /\.\n$/

        false
      end

      # checks whether line contains a MARKDOWN  link to a PR
      def self.with_pr_link?(line)
        return true if line =~ %r{\[\#\d+\]\(https?://github\.com/.*\d+/?\)}

        false
      end

      # checks whether line contains a capitalized Text, treated as a description
      def self.with_changelog_description?(line)
        return true if line =~ /[`[:upper:]].*/

        false
      end

      # checks whether line contains a MARKDOWN  link to an author
      def self.with_author_link?(line)
        return true if line =~ %r{\[@[\w\d\-_]+\]\(https?://github\.com/.*[\w\d\-_]+/?\)}

        false
      end
    end
  end
end
