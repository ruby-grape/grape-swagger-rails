# frozen_string_literal: true

module RuboCop
  module Cop
    module Capybara
      # Checks for redundant `within find(...)` calls.
      #
      # @example
      #   # bad
      #   within find('foo.bar') do
      #     # ...
      #   end
      #
      #   # good
      #   within 'foo.bar' do
      #     # ...
      #   end
      #
      #   # bad
      #   within find_by_id('foo') do
      #     # ...
      #   end
      #
      #   # good
      #   within '#foo' do
      #     # ...
      #   end
      #
      class RedundantWithinFind < ::RuboCop::Cop::Base
        include CssSelector
        extend AutoCorrector
        MSG = 'Redundant `within %<method>s(...)` call detected.'
        RESTRICT_ON_SEND = %i[within].freeze
        FIND_METHODS = Set.new(%i[find find_by_id]).freeze

        # @!method within_find(node)
        def_node_matcher :within_find, <<~PATTERN
          (send nil? :within
            $(send nil? %FIND_METHODS ...))
        PATTERN

        def on_send(node)
          within_find(node) do |find_node|
            add_offense(find_node, message: msg(find_node)) do |corrector|
              corrector.replace(find_node, replaced(find_node))
            end
          end
        end

        private

        def msg(node)
          format(MSG, method: node.method_name)
        end

        def replaced(node)
          unless node.method?(:find_by_id)
            return node.arguments.map(&:source).join(', ')
          end

          if node.first_argument.str_type?
            build_escaped_selector(node.first_argument, node)
          else
            node.arguments.map(&:source).join(', ')
              .sub(/\A(["'])/, '\1#')
          end
        end

        def build_escaped_selector(first_arg, node)
          quote = first_arg.source[0]
          escaped_id = CssSelector.css_escape(first_arg.value, quote)
          rest_args = node.arguments.drop(1).map(&:source)

          ["#{quote}##{escaped_id}#{quote}", *rest_args].join(', ')
        end
      end
    end
  end
end
