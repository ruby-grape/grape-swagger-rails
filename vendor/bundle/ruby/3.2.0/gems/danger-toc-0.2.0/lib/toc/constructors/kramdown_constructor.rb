require 'kramdown/converter'

module Danger
  module Toc
    module Constructors
      class KramdownConstructor < Kramdown::Converter::Toc
        def flatten(el)
          return [] unless el.type == :toc
          result = []
          if el.value
            result << {
              id: el.attr[:id],
              text: el.value.options[:raw_text],
              depth: el.value.options[:level]
            }
          end
          if el.children
            el.children.each do |child|
              result.concat(flatten(child))
            end
          end
          result
        end

        def convert(el)
          toc = flatten(super(el))
          has_toc = false
          headers = []
          toc.each do |line|
            if !has_toc && line[:text] == Danger::Toc.config.header
              headers = [] # drop any headers prior to TOC
              has_toc = true
            else
              headers << line
            end
          end
          headers
        end
      end
    end
  end
end
