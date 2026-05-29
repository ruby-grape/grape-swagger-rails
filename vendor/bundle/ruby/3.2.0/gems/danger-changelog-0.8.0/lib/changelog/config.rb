module Danger
  module Changelog
    module Config
      module_function

      ATTRIBUTES = %i[
        placeholder_line
        filename
        format
        ignore_files
      ].freeze

      ACCESSORS = ATTRIBUTES.map { |name| :"#{name}=" }

      DELEGATORS = ATTRIBUTES + ACCESSORS

      class << self
        attr_accessor(*Config::ATTRIBUTES)
      end

      def placeholder_line=(value)
        if value
          new_value = value
          new_value = "* #{new_value}" unless new_value.start_with?('* ')
          new_value = "#{new_value}\n" unless new_value.end_with?("\n")
          @placeholder_line = new_value
        else
          @placeholder_line = nil
        end
      end

      def format=(value)
        raise ArgumentError, "Invalid format: #{value}" unless Danger::Changelog::Parsers.valid?(value)

        @format = value
      end

      def placeholder_line?
        !@placeholder_line.nil?
      end

      def ignore_files=(value)
        @ignore_files = Array(value)
      end

      def parser
        Danger::Changelog::Parsers.lookup(format)
      end

      def reset
        self.placeholder_line = "* Your contribution here.\n"
        self.filename = 'CHANGELOG.md'
        self.format = Danger::Changelog::Parsers.default_format
        self.ignore_files = ['README.md']
      end

      reset
    end

    class << self
      def configure
        warn '[DEPRECATION] `configure` is deprecated. Please directly configure the Danger plugin via `changelog.xyz=` instead.'
        block_given? ? yield(Config) : Config
      end

      def config
        Config
      end
    end
  end
end
