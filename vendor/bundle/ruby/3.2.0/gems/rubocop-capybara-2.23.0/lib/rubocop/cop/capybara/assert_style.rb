# frozen_string_literal: true

module RuboCop
  module Cop
    module Capybara
      # Checks for usage of deprecated assert style method.
      #
      # @example
      #   # bad
      #   page.find(:css, '#first').assert_style(display: 'block')
      #
      #   # good
      #   page.find(:css, '#first').assert_matches_style(display: 'block')
      #
      class AssertStyle < ::RuboCop::Cop::Base
        extend AutoCorrector

        MSG = 'Use `assert_matches_style` instead of `assert_style`.'
        RESTRICT_ON_SEND = %i[assert_style].freeze

        def on_send(node)
          method_node = node.loc.selector
          add_offense(method_node) do |corrector|
            corrector.replace(method_node, 'assert_matches_style')
          end
        end
      end
    end
  end
end
