require File.expand_path('../../spec_helper', __FILE__)

# The CocoaPods namespace
#
module CLAide
  describe Command::Plugins do
    before do
      argv = CLAide::ARGV.new([])
      @command = Command::Plugins.new(argv)
    end

    it 'registers itself and uses the default subcommand' do
      Command.parse(%w(plugins)).should.be.instance_of Command::Plugins::List
    end

    it 'exists' do
      @command.should.not.be.nil?
    end
  end

  describe Plugins do
    it 'should have a default config' do
      config = CLAide::Plugins.config
      config.should.be.instance_of CLAide::Plugins::Configuration
    end

    it 'should default to a CLAide plugin config' do
      config = CLAide::Plugins::Configuration.new
      config.name.should.equal('default name')
      config.plugin_prefix.should.equal('claide')
      config.plugin_list_url.should.equal('https://github.com/cocoapods/claide-plugins/something.json')
      url = config.plugin_template_url
      url.should.equal('https://github.com/cocoapods/claide-plugins-template')
    end

    it 'should set the plugin_prefix in the claide plugin manager' do
      CLAide::Plugins.config =
        CLAide::Plugins::Configuration.new('testing',
                                           'pants',
                                           'http://example.com/pants.json',
                                           'http://example.com/pants_template')
      CLAide::Plugins.config.plugin_prefix.should.equal('pants')
    end
  end
end
