# frozen_string_literal: true

module RuboCop
  module Cop
    module Capybara
      module RSpec
        # Do not allow negative matchers to be used immediately after `visit`.
        #
        # @example
        #   # bad
        #   visit foo_path
        #   expect(page).to have_no_link('bar')
        #   expect(page).to have_css('a')
        #
        #   # good
        #   visit foo_path
        #   expect(page).to have_css('a')
        #   expect(page).to have_no_link('bar')
        #
        #   # bad
        #   visit foo_path
        #   expect(page).not_to have_link('bar')
        #   expect(page).to have_css('a')
        #
        #   # good
        #   visit foo_path
        #   expect(page).to have_css('a')
        #   expect(page).not_to have_link('bar')
        #
        class NegationMatcherAfterVisit < ::RuboCop::Cop::Base
          include CapybaraHelp

          MSG = 'Do not use negation matcher immediately after visit.'
          RESTRICT_ON_SEND = %i[visit].freeze

          # @!method negation_matcher?(node)
          def_node_matcher :negation_matcher?, <<~PATTERN
            {
              (send (send nil? :expect _) :to (send nil? %NEGATIVE_MATCHERS ...))
              (send (send nil? :expect _) :not_to (send nil? %POSITIVE_MATCHERS ...))
            }
          PATTERN

          def on_send(node)
            negation_matcher?(node.right_sibling) do
              add_offense(node.right_sibling)
            end
          end
        end
      end
    end
  end
end
