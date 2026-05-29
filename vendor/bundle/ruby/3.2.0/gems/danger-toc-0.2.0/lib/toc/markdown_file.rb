require 'active_support/core_ext/string/inflections'

require_relative 'extractor'
require_relative 'constructors'

module Danger
  module Toc
    class MarkdownFile
      attr_reader :filename
      attr_reader :exists
      attr_reader :toc
      attr_reader :headers

      def initialize(filename = 'README.md')
        @filename = filename
        @exists = File.exist?(filename)
        if @exists
          parse!
          reduce!
          validate!
        end
      end

      def exists?
        !!@exists
      end

      def bad?
        !good?
      end

      def good?
        !!@good
      end

      def has_toc?
        !!@has_toc
      end

      def toc_from_headers
        headers.map do |header|
          [
            ' ' * header[:depth] * 2,
            "- [#{header[:text]}]",
            "(##{header[:id]})"
          ].compact.join
        end
      end

      private

      # Parse markdown file for TOC.
      def parse!
        md = File.read(filename)
        doc = Kramdown::Document.new(md, input: 'GFM')

        # extract toc
        toc_start, toc_end = Danger::Toc::Extractor.convert(doc.root).first
        @has_toc = toc_start && toc_end
        @toc = md.split("\n")[toc_start, toc_end - toc_start - 1].reject(&:empty?) if @has_toc

        # construct toc
        @headers = Danger::Toc::Constructors.current.convert(doc.root).first
      end

      def reduce!
        min_depth = nil
        headers.each do |header|
          min_depth = header[:depth] unless min_depth && min_depth < header[:depth]
        end
        if min_depth
          headers.each do |header|
            header[:depth] -= min_depth
          end
        end
      end

      def validate!
        @good = (toc_from_headers == toc)
      end
    end
  end
end
