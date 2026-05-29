# frozen_string_literal: true

module RuboCop
  module Cop
    module Capybara
      module RSpec
        # Checks for usage of `have_content` and `have_no_content`.
        #
        # Capybara provides `have_text` and `have_no_text` matchers that are
        # more concise and preferred over their aliases `have_content` and
        # `have_no_content`.
        #
        # @example
        #   # bad
        #   expect(page).to have_content('capy')
        #   expect(page).to have_no_content('bara')
        #
        #   # good
        #   expect(page).to have_text('capy')
        #   expect(page).to have_no_text('bara')
        #
        class HaveContent < ::RuboCop::Cop::Base
          extend AutoCorrector

          MSG = 'Prefer `%<good>s` over `%<bad>s`.'
          RESTRICT_ON_SEND = %i[have_content have_no_content].freeze
          PREFERRED_METHOD = {
            'have_content' => 'have_text',
            'have_no_content' => 'have_no_text'
          }.freeze

          def on_send(node)
            method_node = node.loc.selector
            add_offense(method_node,
                        message: message(method_node)) do |corrector|
              corrector.replace(method_node,
                                PREFERRED_METHOD[method_node.source])
            end
          end
          alias on_csend on_send

          private

          def message(node)
            format(MSG, good: PREFERRED_METHOD[node.source], bad: node.source)
          end
        end
      end
    end
  end
end
