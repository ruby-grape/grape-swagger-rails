require 'pathname'
ROOT = Pathname.new(File.expand_path('..', __dir__))
$LOAD_PATH.unshift("#{ROOT}lib".to_s)
$LOAD_PATH.unshift("#{ROOT}spec".to_s)

require 'bundler/setup'
require 'pry'

require 'rspec'
require 'danger'

RSpec.configure do |config|
  config.filter_gems_from_backtrace 'bundler'
  config.color = true
  config.tty = true
  config.before do
    Danger::Changelog::Config.reset
  end
end

require 'danger_plugin'

def testing_ui
  Cork::Board.new(silent: true)
end

def testing_env
  {
    'HAS_JOSH_K_SEAL_OF_APPROVAL' => 'true',
    'TRAVIS_PULL_REQUEST' => '800',
    'TRAVIS_REPO_SLUG' => 'dblock/danger-changelog',
    'TRAVIS_COMMIT_RANGE' => '759adcbd0d8f...13c4dc8bb61d',
    'DANGER_GITHUB_API_TOKEN' => '123sbdq54erfsd3422gdfio'
  }
end

# A stubbed out Dangerfile for use in tests
def testing_dangerfile
  env = Danger::EnvironmentManager.new(testing_env)
  Danger::Dangerfile.new(env, testing_ui)
end

require 'active_support'

Dir[File.join(File.dirname(__FILE__), 'support', '**/*.rb')].sort.each do |file|
  require file
end
