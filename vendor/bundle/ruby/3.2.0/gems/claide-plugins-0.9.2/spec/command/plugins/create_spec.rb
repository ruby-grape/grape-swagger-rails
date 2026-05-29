require File.expand_path('../../../spec_helper', __FILE__)
require 'tmpdir'

# The CocoaPods namespace
#
module CLAide
  describe Command::Plugins::Create do
    extend SpecHelper::PluginsCreateCommand

    # We need to have a working repo for the template inside this test
    # suite so we're using the real Danger config file, then setting
    # it back to the default.
    before do
      UI_OUT.reopen
      config = CLAide::Plugins::Configuration.new('Danger',
                                                  'danger',
                                                  'https://raw.githubusercontent.com/danger/danger.systems/master/plugins-search-generated.json',
                                                  'https://github.com/danger/danger-plugin-template')
      CLAide::Plugins.config = config
    end

    after do
      CLAide::Plugins.config = default_testing_config
    end

    it 'registers itself' do
      Command.parse(%w(plugins create)).
        should.be.instance_of Command::Plugins::Create
    end

    #--- Validation

    it 'should require a name is passed in' do
      @command = create_command
      should.raise(CLAide::Help) do
        @command.validate!
      end.message.should.match(/A name for the plugin is required./)
    end

    it 'should require a non-empty name is passed in' do
      @command = create_command('')
      should.raise(CLAide::Help) do
        @command.validate!
      end.message.should.match(/A name for the plugin is required./)
    end

    it 'should require the name does not have spaces' do
      @command = create_command('my gem')
      should.raise(CLAide::Help) do
        @command.validate!
      end.message.should.match(/The plugin name cannot contain spaces./)
    end

    #--- Naming

    # These have to be `danger` as the configure script runs from the danger
    # plugin template repo.

    it 'should prefix the given name if not already' do
      @command = create_command('unprefixed')
      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do
          @command.run
        end
      end
      UI_OUT.string.should.include('Creating `danger-unprefixed` plugin')
    end

    it 'should not prefix the name if already prefixed' do
      @command = create_command('danger-prefixed')
      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do
          @command.run
        end
      end
      UI_OUT.string.should.include('Creating `danger-prefixed` plugin')
    end

    #--- Template download

    it 'should download the default template repository' do
      @command = create_command('danger-banana')

      template_repo = 'https://github.com/danger/' \
        'danger-plugin-template'
      git_command = ['clone', template_repo, 'danger-banana']
      CLAide::TemplateRunner.any_instance.expects(:git!).with(git_command)
      CLAide::TemplateRunner.any_instance.expects(:configure_template)
      @command.run
      UI_OUT.string.should.include('Creating `danger-banana` plugin')
    end

    it 'should download the passed in template repository' do
      alt_repo = 'https://github.com/danger/' \
        'danger-banana-plugin-template'
      @command = create_command('danger-banana', alt_repo)

      git_command = ['clone', alt_repo, 'danger-banana']
      CLAide::TemplateRunner.any_instance.expects(:git!).with(git_command)
      CLAide::TemplateRunner.any_instance.expects(:configure_template)
      @command.run
      UI_OUT.string.should.include('Creating `danger-banana` plugin')
    end
  end
end
