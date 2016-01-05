require 'rubygems'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

require 'sass'
require 'grape'
require 'grape-swagger'
require 'coffee_script'
