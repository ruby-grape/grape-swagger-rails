# frozen_string_literal: true

module RuboCop
  module Cop
    module Capybara
      module RSpec
        # Checks for usage of deprecated style methods in RSpec matchers.
        #
        # @example when using `has_style?`
        #   # bad
        #   expect(page.find(:css, 'first')
        #     .has_style?(display: 'block')).to be true
        #
        #   # good
        #   expect(page.find(:css, 'first')
        #     .matches_style?(display: 'block')).to be true
        #
        # @example when using `have_style`
        #   # bad
        #   expect(page).to have_style(display: 'block')
        #
        #   # good
        #   expect(page).to match_style(display: 'block')
        #
        class MatchStyle < ::RuboCop::Cop::Base
          extend AutoCorrector

          MSG = 'Use `%<good>s` instead of `%<bad>s`.'
          RESTRICT_ON_SEND = %i[has_style? have_style].freeze
          PREFERRED_METHOD = {
            'has_style?' => 'matches_style?',
            'have_style' => 'match_style'
          }.freeze

          def on_send(node)
            method_node = node.loc.selector
            preferred = PREFERRED_METHOD[method_node.source]
            add_offense(method_node,
                        message: message(preferred, method_node)) do |corrector|
              corrector.replace(method_node, preferred)
            end
          end

          private

          def message(preferred, method_node)
            format(MSG, good: preferred, bad: method_node.source)
          end
        end
      end
    end
  end
end
