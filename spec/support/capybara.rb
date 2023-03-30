# frozen_string_literal: true

require 'capybara/rspec'
require 'capybara/rails'

Capybara.default_driver = :selenium
Capybara.server_port = 3000
Capybara.server = :webrick
