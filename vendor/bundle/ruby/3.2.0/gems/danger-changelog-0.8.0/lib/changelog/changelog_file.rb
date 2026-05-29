module Danger
  module Changelog
    # A CHANGELOG.md file reader.
    class ChangelogFile
      attr_reader :filename, :bad_lines, :exists, :global_failures

      def initialize(filename = 'CHANGELOG.md', parser: Parsers.lookup(Parsers.default_format))
        @filename = filename
        @exists = File.exist?(filename)
        @bad_lines = []
        @global_failures = []
        @parser = parser

        parser.add_listener(self)
      end

      def add_bad_line(line, detail = nil)
        return unless line || detail

        @bad_lines << [line, detail].compact
      end

      def add_global_failure(message)
        @global_failures << message
      end

      def parse
        return unless exists?

        @parser.parse(filename)
      end

      # Any bad_lines?
      def bad_lines?
        bad_lines.any?
      end

      def global_failures?
        global_failures.any?
      end

      def exists?
        @exists
      end

      def bad?
        bad_lines? || global_failures?
      end

      def good?
        !bad?
      end
    end
  end
end
