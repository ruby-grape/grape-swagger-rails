# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpecRails
      # Enforces consistency by using the current HTTP status names.
      #
      # @example
      #
      #   # bad
      #   it { is_expected.to have_http_status :unprocessable_entity }
      #
      #   # good
      #   it { is_expected.to have_http_status :unprocessable_content }
      #
      class HttpStatusNameConsistency < ::RuboCop::Cop::Base
        extend AutoCorrector

        requires_gem 'rack', '>= 3.1.0'

        MSG = 'Use `Prefer `:%<preferred>s` over `:%<current>s`.'

        RESTRICT_ON_SEND = %i[have_http_status].freeze

        PREFERRED_STATUSES = {
          unprocessable_entity: :unprocessable_content,
          payload_too_large: :content_too_large
        }.freeze

        # @!method http_status(node)
        def_node_matcher :http_status, <<~PATTERN
          (send nil? :have_http_status ${sym})
        PATTERN

        def on_send(node)
          http_status(node) do |arg|
            check_status_name_consistency(arg)
          end
        end
        alias on_csend on_send

        private

        def check_status_name_consistency(node)
          return unless node.sym_type? && PREFERRED_STATUSES.key?(node.value)

          current_status = node.value
          preferred_status = PREFERRED_STATUSES[current_status]

          message = format(MSG, current: current_status,
                                preferred: preferred_status)

          add_offense(node, message: message) do |corrector|
            corrector.replace(node, ":#{preferred_status}")
          end
        end
      end
    end
  end
end
