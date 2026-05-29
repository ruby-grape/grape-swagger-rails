require File.expand_path('../../../spec_helper', __FILE__)

# The CocoaPods namespace
#
module CLAide
  describe Command::Plugins::List do
    extend SpecHelper::PluginsStubs

    before do
      UI_OUT.reopen
      @command = CLAide::Command::Plugins::List.new CLAide::ARGV.new []
    end

    it 'registers itself' do
      Command.parse(%w(plugins list)).
        should.be.instance_of Command::Plugins::List
    end

    #--- Output printing

    it 'prints out all plugins' do
      stub_plugins_json_request
      @command.run
      UI_OUT.string.should.include('github.com/CLAide/claide-fake-1')
      UI_OUT.string.should.include('github.com/CLAide/claide-fake-2')
      UI_OUT.string.should.include('github.com/chneukirchen/bacon')
    end
  end
end
