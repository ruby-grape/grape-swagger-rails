# frozen_string_literal: true

module RuboCop
  module Cop
    module Capybara
      module RSpec
        # Enforces use of `have_no_*` or `not_to` for negated expectations.
        #
        # @example EnforcedStyle: have_no (default)
        #   # bad
        #   expect(page).not_to have_selector 'a'
        #   expect(page).not_to have_css('a')
        #
        #   # good
        #   expect(page).to have_no_selector 'a'
        #   expect(page).to have_no_css('a')
        #
        # @example EnforcedStyle: not_to
        #   # bad
        #   expect(page).to have_no_selector 'a'
        #   expect(page).to have_no_css('a')
        #
        #   # good
        #   expect(page).not_to have_selector 'a'
        #   expect(page).not_to have_css('a')
        #
        class NegationMatcher < ::RuboCop::Cop::Base
          extend AutoCorrector
          include ConfigurableEnforcedStyle
          include CapybaraHelp

          MSG = 'Use `expect(...).%<runner>s %<matcher>s`.'
          RESTRICT_ON_SEND = (POSITIVE_MATCHERS + NEGATIVE_MATCHERS).freeze

          # @!method not_to?(node)
          def_node_matcher :not_to?, <<~PATTERN
            (send ... {:not_to :to_not}
              (send nil? %POSITIVE_MATCHERS ...))
          PATTERN

          # @!method have_no?(node)
          def_node_matcher :have_no?, <<~PATTERN
            (send ... :to
              (send nil? %NEGATIVE_MATCHERS ...))
          PATTERN

          def on_send(node)
            return unless offense?(node)

            matcher = node.method_name.to_s
            add_offense(offense_range(node),
                        message: message(matcher)) do |corrector|
              corrector.replace(node.parent.loc.selector, replaced_runner)
              corrector.replace(node.loc.selector,
                                replaced_matcher(matcher))
            end
          end

          private

          def offense?(node)
            node.arguments? &&
              ((style == :have_no && not_to?(node.parent)) ||
              (style == :not_to && have_no?(node.parent)))
          end

          def offense_range(node)
            node.parent.loc.selector.with(end_pos: node.loc.selector.end_pos)
          end

          def message(matcher)
            format(MSG,
                   runner: replaced_runner,
                   matcher: replaced_matcher(matcher))
          end

          def replaced_runner
            case style
            when :have_no
              'to'
            when :not_to
              'not_to'
            else
              # :nocov:
              :noop
              # :nocov:
            end
          end

          def replaced_matcher(matcher)
            case style
            when :have_no
              matcher.sub('have_', 'have_no_')
            when :not_to
              matcher.sub('have_no_', 'have_')
            else
              # :nocov:
              :noop
              # :nocov:
            end
          end
        end
      end
    end
  end
end
