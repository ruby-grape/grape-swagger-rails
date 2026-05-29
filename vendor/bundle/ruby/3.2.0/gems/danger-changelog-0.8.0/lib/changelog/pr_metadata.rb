module Danger
  module Changelog
    class PRMetadata
      EXAMPLE_PR_JSON = {
        'number' => 123,
        'html_url' => 'https://github.com/org/repo/pull/123'
      }.freeze
      EXAMPLE_TITLE = 'Your contribution'.freeze
      EXAMPLE_AUTHOR = 'username'.freeze

      attr_reader :pr_json, :pr_title, :pr_author

      def initialize(pr_json:, pr_title:, pr_author:)
        @pr_json = pr_json
        @pr_title = pr_title
        @pr_author = pr_author
      end

      # Attempt to fetch PR metadata from the GitHub plugin.
      # Returns nil if GitHub API access fails for any reason (authentication, rate limiting, network errors, etc).
      # This allows the fallback chain to proceed to other sources like GITHUB_EVENT_PATH.
      def self.from_github_plugin(github = nil)
        return nil unless github

        begin
          pr_json = github.pr_json
          return nil unless pr_json

          new(
            pr_json: pr_json,
            pr_title: github.pr_title,
            pr_author: github.pr_author
          )
        rescue Octokit::Error => e
          warn "[Changelog::PRMetadata] GitHub API request failed (#{e.class}: #{e.message}). Falling back to other PR metadata sources."
          nil
        end
      end

      def self.from_event_file(path)
        return nil unless path
        return nil unless File.exist?(path)

        event = JSON.parse(File.read(path))
        pr = event['pull_request']
        return nil unless pr

        new(
          pr_json: pr,
          pr_title: pr['title'],
          pr_author: pr.dig('user', 'login')
        )
      end

      def self.fallback
        new(
          pr_json: EXAMPLE_PR_JSON,
          pr_title: EXAMPLE_TITLE,
          pr_author: EXAMPLE_AUTHOR
        )
      end
    end
  end
end
