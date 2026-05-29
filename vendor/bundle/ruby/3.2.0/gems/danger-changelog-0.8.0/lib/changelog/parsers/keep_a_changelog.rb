module Danger
  module Changelog
    module Parsers
      class KeepAChangelog < Base
        def bad_line_message(filename)
          "One of the lines below found in #{filename} doesn't match the " \
            '[expected format](https://keepachangelog.com).'
        end

        def parse(filename)
          blocks = parse_into_blocks(File.open(filename).each_line)

          if contains_header_block?(blocks.first)
            blocks = blocks[1..]
          else
            notify_of_global_failure(
              'The changelog is missing the version header for the Keep A ' \
              'Changelog format. See <https://keepachangelog.com> to see ' \
              'the format of the header.'
            )
          end

          blocks.each do |header, *body|
            notify_of_bad_line(header) unless ChangelogHeaderLine.new(header).valid?

            body.each do |line|
              next if approved_section?(line)
              next if markdown_link?(line)
              next if markdown_list_item_or_continuation?(line)

              notify_of_bad_line(line)
            end
          end
        end

        private

        def parse_into_blocks(lines)
          blocks = []
          block = []

          lines.each do |line|
            line = line.chomp

            if /^##?[^#]/.match?(line)
              blocks << block.dup unless block.empty?
              block.clear
            end

            block << line unless line.empty?
          end

          blocks << block.dup
        end

        def approved_section?(line)
          /^### (Added|Changed|Deprecated|Removed|Fixed|Security)/.match?(line)
        end

        def contains_header_block?(block)
          return false unless block
          return false unless block.first == '# Changelog'

          regex = %r{All notable changes to this project will be documented in this file. The format is based on \[Keep a Changelog\]\(https://keepachangelog.com/en/\d\.\d\.\d/\), and this project adheres to \[Semantic Versioning\]\(https://semver.org/spec/v2.0.0.html\).}

          block_content = block[1..].join(' ')

          regex.match?(block_content)
        end

        def markdown_link?(line)
          /^\[.*\]:/.match?(line)
        end

        def markdown_list_item_or_continuation?(line)
          /^(?:[*-]\s|  )/.match?(line)
        end
      end
    end
  end
end
