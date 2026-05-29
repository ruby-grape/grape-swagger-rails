# frozen_string_literal: true

module RuboCop
  module Cop
    module Capybara
      # Specify the exact target to click on.
      #
      # In projects where accessibility needs to be considered,
      # it is crucial to specify the click target precisely.
      #
      # @example
      #   # bad
      #   click_link_or_button('foo')
      #   click_on('foo')
      #
      #   # good
      #   click_link('foo')
      #   click_button('foo')
      #
      class AmbiguousClick < ::RuboCop::Cop::Base
        MSG = 'Use `click_link` or `click_button` instead of `%<method>s`.'
        RESTRICT_ON_SEND = %i[click_link_or_button click_on].freeze

        def on_send(node)
          add_offense(node, message: format(MSG, method: node.method_name))
        end
      end
    end
  end
end
