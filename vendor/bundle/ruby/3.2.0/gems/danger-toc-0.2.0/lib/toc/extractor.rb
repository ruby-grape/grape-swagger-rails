require 'kramdown/converter'

module Danger
  module Toc
    class Extractor < Kramdown::Converter::Base
      def initialize(root, options)
        super
        @toc_start = nil
        @toc_end = nil
        @in_toc = false
      end

      def convert(el)
        if el.type == :header && el.options[:raw_text] == Danger::Toc.config.header
          @in_toc = true
          @toc_start = el.options[:location]
        elsif el.type == :header
          @toc_end = el.options[:location] if @in_toc && !@toc_end
          @in_toc = false
        else
          el.children.each { |child| convert(child) }
        end
        [@toc_start, @toc_end]
      end
    end
  end
end
