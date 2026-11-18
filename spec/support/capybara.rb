# frozen_string_literal: true

require 'capybara/rspec'
require 'capybara/rails'

Capybara.default_driver = ENV['HEADLESS'] == 'true' ? :selenium_headless : :selenium
Capybara.server_port = 3000
Capybara.server = :webrick
Capybara.app_host = "http://localhost:#{Capybara.server_port}"
