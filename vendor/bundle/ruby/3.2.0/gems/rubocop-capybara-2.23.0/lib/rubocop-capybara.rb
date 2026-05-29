# frozen_string_literal: true

require 'pathname'
require 'yaml'

require 'rubocop'

require_relative 'rubocop/capybara/plugin'
require_relative 'rubocop/capybara/version'

require_relative 'rubocop/cop/capybara/mixin/capybara_help'
require_relative 'rubocop/cop/capybara/mixin/css_attributes_parser'
require_relative 'rubocop/cop/capybara/mixin/css_selector'

require_relative 'rubocop/cop/capybara_cops'

RuboCop::Cop::Style::TrailingCommaInArguments.singleton_class.prepend(
  Module.new do
    def autocorrect_incompatible_with
      super.push(RuboCop::Cop::Capybara::RSpec::CurrentPathExpectation)
    end
  end
)
