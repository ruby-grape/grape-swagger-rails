# encoding: utf-8

module Cork
  module TextWrapper
    # @return [String] Wraps a formatted string (e.g. markdown) by stripping
    #          heredoc indentation and wrapping by word to the terminal width
    #          taking into account a maximum one, and indenting the string.
    #          Code lines (i.e. indented by four spaces) are not wrapped.
    #
    # @param   [String] string
    #        The string to format.
    #
    # @param    [Fixnum] indent
    #          The number of spaces to insert before the string.
    #
    # @param   [Fixnum] width
    #         The width to use to format the string if the terminal
    #         is too wide.
    #
    def wrap_formatted_text(string, indent = 0, width = 80)
      paragraphs = strip_heredoc(string).split("\n\n")
      paragraphs = paragraphs.map do |paragraph|
        if paragraph.start_with?(' ' * 4)
          paragraphs.gsub!(/\n/, "\n#{' ' * indent}")
        else
          paragraph = wrap_with_indent(paragraph, indent, width)
        end
        paragraph.insert(0, ' ' * indent).rstrip
      end
      paragraphs.join("\n\n")
    end

    module_function :wrap_formatted_text

    # @return [String] Wraps a string to the terminal width taking into
    #         account the given indentation.
    #
    # @param  [String] string
    #         The string to indent.
    #
    # @param  [Fixnum] indent
    #         The number of spaces to insert before the string.
    #
    # @param  [Fixnum] width
    #         The width to use when formatting the string in the terminal
    #
    def wrap_with_indent(string, indent = 0, width = 80)
      full_line = string.gsub("\n", ' ')
      available_width = width - indent
      space = ' ' * indent
      word_wrap(full_line, available_width).split("\n").join("\n#{space}")
    end

    module_function :wrap_with_indent

    # @return [String] Lifted straigth from Actionview. Thanks Guys!
    #
    def word_wrap(line, line_width)
      line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip
    end

    module_function :word_wrap

    # @return [String] Lifted straigth from Actionview. Thanks Guys!
    #
    def strip_heredoc(string)
      if min = string.scan(/^[ \t]*(?=\S)/).min
        string.gsub(/^[ \t]{#{min.size}}/, '')
      else
        string
      end
    end

    module_function :strip_heredoc
  end
end
