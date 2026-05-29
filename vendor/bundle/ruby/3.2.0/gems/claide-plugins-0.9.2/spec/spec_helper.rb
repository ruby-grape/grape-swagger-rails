# Set up coverage analysis
#-----------------------------------------------------------------------------#

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.configure do |config|
  config.logger.level = Logger::WARN
end
CodeClimate::TestReporter.start

# Set up
#-----------------------------------------------------------------------------#

require 'pathname'
ROOT = Pathname.new(File.expand_path('../../', __FILE__))
$LOAD_PATH.unshift((ROOT + 'lib').to_s)
$LOAD_PATH.unshift((ROOT + 'spec').to_s)

require 'bundler/setup'
require 'bacon'
require 'mocha-on-bacon'
require 'pretty_bacon'

require 'webmock'
include WebMock::API

require 'claide_plugin'

# VCR
#--------------------------------------#

require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = ROOT + 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_hosts 'codeclimate.com'
end

#-----------------------------------------------------------------------------#

# Disable the wrapping so the output is deterministic in the tests.
#
UI_OUT = StringIO.new
UI_ERR = StringIO.new
UI = Cork::Board.new(:out => UI_OUT, :err => UI_ERR)

UI.disable_wrap = true

#-----------------------------------------------------------------------------#

# Bacon namespace
#
module Bacon
  # Add a fixture helper to the Bacon Context
  class Context
    ROOT = ::ROOT + 'spec/fixtures'

    def fixture(name)
      ROOT + name
    end
  end
end

#-----------------------------------------------------------------------------#

# Use test specific settings inside all of the tests
#

def default_testing_config
  CLAide::Plugins::Configuration.new('CLAideTesting',
                                     'claidetest',
                                     'https://github.com/cocoapods/claide-plugins/something.json',
                                     'https://github.com/danger/danger-plugin-template')
end

CLAide::Plugins.config = default_testing_config
#-----------------------------------------------------------------------------#

# SpecHelper namespace
#
module SpecHelper
  # Add this as an extension into the Search and List specs
  # to help stub the plugins.json request
  module PluginsStubs
    def stub_plugins_json_request(json = nil, status = 200)
      body = json || File.read(fixture('plugins.json'))
      stub_request(:get, 'http://example.com/pants.json').
        to_return(:status => status, :body => body, :headers => {})
      stub_request(:get, 'https://github.com/cocoapods/claide-plugins/something.json').
        to_return(:status => status, :body => body, :headers => {})
    end
  end

  # Add this as an extension into the Create specs
  module PluginsCreateCommand
    def create_command(*args)
      CLAide::Command::Plugins::Create.new CLAide::ARGV.new(args)
    end
  end

  # Add this as an extension into the Search specs
  module PluginsSearchCommand
    def search_command(*args)
      CLAide::Command::Plugins::Search.new CLAide::ARGV.new(args)
    end
  end
end
