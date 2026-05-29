require 'colored2'

module Cork
  # provides support for UI output. Cork provides support for nested
  # sections of information and for a verbose mode.
  #

  class Board
    # @return [input] The input specification that contains the user input
    #          for the UI.
    #
    attr_reader :input
    # @return [output] The output specification containing the UI output.
    attr_reader :out
    # @return [error] The error specification containing the UI error.
    attr_reader :err
    # @return [warnings] The warnings specification containing the UI warnings.
    attr_reader :warnings
    # @return [Bool] Whether the wrapping of the strings to the width of the
    #         terminal should be disabled.
    #
    attr_accessor :disable_wrap
    alias_method :disable_wrap?, :disable_wrap

    attr_reader :verbose
    alias_method :verbose?, :verbose

    attr_reader :silent
    alias_method :silent?, :silent

    attr_reader :ansi
    alias_method :ansi?, :ansi

    attr_accessor :indentation_level
    attr_accessor :title_level

    # Initialize a new instance.
    #
    # @param [Boolean] verbose When verbose is true verbose output is printed.
    #        this defaults to true
    # @param [Boolean] silent When silent is true all output is supressed.
    #        This defaults to false.
    # @param [Boolean] ansi When ansi is true output may contain ansi
    #        color codes. This is true by default.
    # @param [IO] input The file descriptor to read the user input.
    # @param [IO] out The file descriptor to print all output to.
    # @param [IO] err The file descriptor to print all errors to.
    #
    def initialize(verbose: false, silent: false, ansi: true,
      input: $stdin, out: $stdout, err: $stderr)

      @input = input
      @out = out
      @err = err
      @verbose = verbose
      @silent = silent
      @ansi = ansi
      @warnings = []
      @title_colors      =  %w(    yellow green    )
      @title_level       =  0
      @indentation_level =  2
    end

    # Prints a message followed by a new line unless silent.
    #
    def puts(message = '')
      out.puts(message) unless silent?
    end

    # Prints a message without a new line unless silent.
    #
    def print(message)
      out.print(message) unless silent?
    end

    # Prints a message respecting the current indentation level and
    # wrapping it to the terminal width if necessary.
    #
    def puts_indented(message = '')
      indented = wrap_string(message, @indentation_level)
      puts(indented)
    end

    # Gets input from the configured input.
    #
    def gets
      input.gets
    end

    # Stores important warning to the user optionally followed by actions that
    # the user should take. To print them use {#print_warnings}.
    #
    #  @param [String]  message The message to print.
    #  @param [Array]   actions The actions that the user should take.
    #  @param [Boolean] verbose_only When verbose_only is configured to
    #                   true, the warning will only be printed when
    #                   Board is configured to print verbose messages.
    #                   This is false by default.
    #
    #  @return [void]
    #
    def warn(message, actions = [], verbose_only = false)
      warnings << {
        :message      => message,
        :actions      => actions,
        :verbose_only => verbose_only,
      }
    end

    # The returned path is quoted. If the argument is nil it returns an empty
    # string.
    #
    # @param [#to_str,Nil] pathname
    #        The path to return.
    # @param [Pathname] relative_to
    #
    def path(pathname, relative_to = Pathname.pwd)
      if pathname
        path = Pathname(pathname).relative_path_from(relative_to)
        "`#{path}`"
      else
        ''
      end
    end

    # Prints a message with a label.
    #
    # @param [String] label
    #        The label to print.
    #
    # @param [#to_s] value
    #        The value to print.
    #
    # @param [FixNum] justification
    #        The justification of the label.
    #
    def labeled(label, value, justification = 12)
      if value
        title = "- #{label}:"
        if value.is_a?(Enumerable)
          lines = [wrap_string(title, indentation_level)]
          lines += value.map do |v|
            wrap_string("- #{v}", indentation_level + 2)
          end
          puts lines.join("\n")
        else
          string = title.ljust(justification) + "#{value}"
          puts wrap_string(string, indentation_level)
        end
      end
    end

    # Prints a title taking an optional verbose prefix and
    # a relative indentation valid for the UI action in the passed
    # block.
    #
    # In verbose mode titles are printed with a color according
    # to their level. In normal mode titles are printed only if
    # they have nesting level smaller than 2.
    #
    # @todo Refactor to title (for always visible titles like search)
    #       and sections (titles that represent collapsible sections).
    #
    # @param [String] title
    #        The title to print
    #
    # @param [String] verbose_prefix
    #        See #message
    #
    # @param [FixNum] relative_indentation
    #        The indentation level relative to the current,
    #        when the message is printed.
    #
    def section(title, verbose_prefix = '', relative_indentation = 0,
                titled = false)
      if verbose?
        title(title, verbose_prefix, relative_indentation)
      elsif title_level < 1 || titled
        puts title
      end

      @indentation_level += relative_indentation
      @title_level += 1
      yield if block_given?
      @indentation_level -= relative_indentation
      @title_level -= 1
    end

    # Prints an info to the user. The info is always displayed.
    # It respects the current indentation level only in verbose
    # mode.
    #
    # Any title printed in the optional block is treated as a message.
    #
    # @param [String] message
    #        The message to print.
    #
    def info(message)
      indentation = verbose? ? @indentation_level : 0
      indented = wrap_string(message, indentation)
      puts(indented)

      if block_given?
        @indentation_level += 2
        @treat_titles_as_messages = true
        yield
        @treat_titles_as_messages = false
        @indentation_level -= 2
      end
    end

    # A title opposed to a section is always visible
    #
    # @param [String] title
    #         The title to print
    #
    # @param [String] verbose_prefix
    #         See #message
    #
    # @param [FixNum] relative_indentation
    #         The indentation level relative to the current,
    #         when the message is printed.
    #
    def title(title, verbose_prefix = '', relative_indentation = 2)
      if @treat_titles_as_messages
        message(title, verbose_prefix)
      else
        puts_title(title, verbose_prefix)
      end

      if block_given?
        @indentation_level += relative_indentation
        @title_level += 1
        yield
        @indentation_level -= relative_indentation
        @title_level -= 1
      end
    end

    # Prints a verbose message taking an optional verbose prefix and
    # a relatvie indentation valid for the UI action in the passed block.
    #
    def notice(message)
      line = "\n[!] #{message}"
      line = line.green if ansi?
      puts(line)
    end

    # @todo Clean interface.
    #
    # @param [String] message
    #       The message to print.
    #
    # @param [String] verbose_prefix
    #        See #message
    #
    # @param [FixNum] relative_indentation
    #         The indentation level relative to the current,
    #         when the message is printed.
    #

    # Prints the stored warnings. This method is intended to be called at the
    # end of the execution of the binary.
    #
    # @return [void]
    #
    def print_warnings
      out.flush
      warnings.each do |warning|
        next if warning[:verbose_only] && !verbose?

        message = "\n[!] #{warning[:message]}"
        message = message.yellow if ansi?
        err.puts(message)

        warning[:actions].each do |action|
          string = "- #{action}"
          string = wrap_string(string, 4)
          err.puts(string)
        end
      end
    end

    # Prints a verbose message taking an optional verbose prefix and
    # a relative indentation valid for the UI action in the passed
    # block.
    #
    # @todo Clean interface.
    #
    def message(message, verbose_prefix = '', relative_indentation = 2)
      message = verbose_prefix + message if verbose?
      puts_indented message if verbose?

      @indentation_level += relative_indentation
      yield if block_given?
      @indentation_level -= relative_indentation
    end

    private

    # @!group Helpers

    attr_writer :indentation_level
    attr_accessor :title_level

    # Prints a title taking an optional verbose prefix and
    # a relative indentation valid for the UI action in the passed
    # block.
    #
    # In verbose mode titles are printed with a color according
    # to their level. In normal mode titles are printed only if
    # they have nesting level smaller than 2.
    #
    # @todo Refactor to title (for always visible titles like search)
    #       and sections (titles that represent collapsible sections).
    #
    # @param [String] title
    #        The title to print
    #
    # @param [String] verbose_prefix
    #        See #message
    #
    # @param [FixNum] relative_indentation
    #        The indentation level relative to the current,
    #        when the message is printed.
    #

    def wrap_string(string, indent = 0)
      first_space = ' ' * indent
      if disable_wrap || !out.tty?
        first_space << string
      else
        require 'io/console'
        columns = out.winsize[1]
        indented = TextWrapper.wrap_with_indent(string, indent, columns)
        first_space << indented
      end
    end

    def puts_title(title, verbose_prefix)
      title = verbose_prefix + title if verbose?
      title = "\n#{title}" if @title_level < 2
      if ansi? && (color = @title_colors[title_level])
        title = title.send(color)
      end
      puts "#{title}"
    end
  end
end
