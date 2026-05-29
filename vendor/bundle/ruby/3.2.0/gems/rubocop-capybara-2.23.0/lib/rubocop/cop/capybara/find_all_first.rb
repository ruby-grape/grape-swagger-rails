# frozen_string_literal: true

module RuboCop
  module Cop
    module Capybara
      # Enforces use of `first` instead of `all` with `first` or `[0]`.
      #
      # @safety
      #   This cop's autocorrection is unsafe because `all` returns a
      #   `Capybara::Result` (an enumerable collection), while `first`
      #   returns a single `Capybara::Node::Element`. Replacing `all`
      #   with `first` may break code that depends on the return value
      #   being a collection (e.g. calling `.each` on the result).
      #
      # @example
      #
      #   # bad
      #   all('a').first
      #   all('a')[0]
      #   find('a', match: :first)
      #   all('a', match: :first)
      #
      #   # good
      #   first('a')
      #
      class FindAllFirst < ::RuboCop::Cop::Base
        extend AutoCorrector
        include RangeHelp

        MSG = 'Use `first(%<selector>s)`.'
        RESTRICT_ON_SEND = %i[all find].freeze

        # @!method find_all_first?(node)
        def_node_matcher :find_all_first?, <<~PATTERN
          {
            (send (send _ :all _ ...) :first)
            (send (send _ :all _ ...) :[] (int 0))
          }
        PATTERN

        # @!method include_match_first?(node)
        def_node_matcher :include_match_first?, <<~PATTERN
          (send _ {:find :all} _ $(hash <(pair (sym :match) (sym :first)) ...>))
        PATTERN

        def on_send(node)
          on_all_first(node)
          on_match_first(node)
        end

        private

        def on_all_first(node)
          return unless (parent = node.parent)
          return unless find_all_first?(parent)
          return if part_of_logical_operator?(parent)

          range = range_between(node.loc.selector.begin_pos,
                                parent.loc.selector.end_pos)
          selector = node.arguments.map(&:source).join(', ')
          add_offense(range,
                      message: format(MSG, selector: selector)) do |corrector|
            corrector.replace(range, "first(#{selector})")
          end
        end

        def on_match_first(node)
          include_match_first?(node) do |hash|
            selector = ([node.first_argument.source] + replaced_hash(hash))
              .join(', ')
            range = range_between(node.loc.selector.begin_pos,
                                  node.source_range.end_pos)
            add_offense(range,
                        message: format(MSG, selector: selector)) do |corrector|
              corrector.replace(range, "first(#{selector})")
            end
          end
        end

        def replaced_hash(hash)
          hash.child_nodes.flat_map(&:source).reject do |arg|
            arg == 'match: :first'
          end
        end

        def part_of_logical_operator?(node)
          node.ancestors.any?(&:operator_keyword?)
        end
      end
    end
  end
end
