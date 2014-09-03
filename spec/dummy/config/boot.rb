require 'rubygems'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

require 'grape'
require 'grape-swagger'
require 'sass'
require 'coffee_script'
