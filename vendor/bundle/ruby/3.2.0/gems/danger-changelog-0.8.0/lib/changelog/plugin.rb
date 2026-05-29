module Danger
  # Enforce CHANGELOG.md O.C.D. in your projects.
  #
  # This plugin can, for example, make sure the changes are attributes properly and that they are always terminated with a period.
  #
  # @example Run all checks on the default CHANGELOG.md.
  #
  #          changelog.check!
  #
  # @example Customize the CHANGELOG file name and remind the requester to update it when necessary.
  #
  #          changelog.filename = 'CHANGES.md'
  #          changelog.placeholder_line = "* Your contribution here.\n"
  #          changelog.have_you_updated_changelog?
  #
  # @see  dblock/danger-changelog
  # @tags changelog

  class DangerChangelog < Plugin
    extend Forwardable

    def_delegators Danger::Changelog.config, *Danger::Changelog::Config::DELEGATORS

    # Run all checks.
    # @return [Boolean] true when the check passes
    def check!
      have_you_updated_changelog? && is_changelog_format_correct?
    end

    # Run all checks.
    # @param parser [Symbol] the parser to check with
    # @return [Boolean] true when the check passes
    def check(parser = Danger::Changelog::Config.format)
      warn '[DEPRECATION] `check` is deprecated. Set format with `.format` and use `check!` instead.'
      config.format = parser
      check!
    end

    # Has the CHANGELOG file been modified?
    # @return [boolean]
    def changelog_changes?
      git.modified_files.include?(filename) || git.added_files.include?(filename)
    end

    # Are any files CHANGELOG cares about modified?
    # @return [boolean]
    def file_changes?
      all_files = git.modified_files + git.added_files
      Danger::Changelog::Config.ignore_files.each do |f|
        all_files.reject! { |modified_file| f.is_a?(Regexp) ? f.match?(modified_file) : f == modified_file }
        break if all_files.empty?
      end
      all_files.any?
    end

    # Have you updated CHANGELOG.md?
    # @return [boolean]
    def have_you_updated_changelog?
      if changelog_changes?
        true
      elsif file_changes?
        warn_update_changelog
        false
      else
        true
      end
    end

    # Is the CHANGELOG.md format correct?
    # @return  [boolean]
    def is_changelog_format_correct?
      parser = Danger::Changelog::Config.parser
      changelog_file = Danger::Changelog::ChangelogFile.new(filename, parser: parser)

      if changelog_file.exists?
        changelog_file.parse
        changelog_file.bad_lines.each do |line|
          markdown <<~MARKDOWN
            ```markdown
            #{line.map(&:strip).join("\n")}
            ```
          MARKDOWN
        end
        messaging.fail(parser.bad_line_message(filename), sticky: false) if changelog_file.bad_lines?

        changelog_file.global_failures.each do |failure|
          messaging.fail(failure, sticky: false)
        end

        changelog_file.good?
      else
        messaging.fail("The #{filename} file does not exist.", sticky: false)
        false
      end
    end

    private

    def pr_metadata
      Danger::Changelog::PRMetadata.from_event_file(ENV.fetch('GITHUB_EVENT_PATH', nil)) ||
        Danger::Changelog::PRMetadata.from_github_plugin(github_plugin) ||
        Danger::Changelog::PRMetadata.fallback
    end

    def github_plugin
      github
    rescue NoMethodError
      # github plugin is not available in dry_run mode (LocalOnly request source)
      nil
    end

    def warn_update_changelog
      example = Danger::Changelog::ChangelogEntryLine.example(pr_metadata)

      markdown <<~MARKDOWN
        Here's an example of a #{filename} entry:

        ```markdown
        #{example}
        ```
      MARKDOWN
      warn "Unless you're refactoring existing code or improving documentation, please update #{filename}.", sticky: false
    end
  end
end
