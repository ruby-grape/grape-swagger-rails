require File.expand_path('../spec_helper', File.dirname(__FILE__))

# The CocoaPods namespace
#
module CLAide
  describe Command::GemIndexCache do
    before do
      @cache = Command::GemIndexCache.new
      UI_OUT.reopen
    end

    after do
      mocha_teardown
    end

    it 'notifies the user that it is downloading the spec index' do
      response = [{}, []]
      Gem::SpecFetcher.any_instance.stubs(:available_specs).returns(response)

      @cache.download_and_cache_specs
      out = UI_OUT.string
      out.should.include('Downloading Rubygem specification index...')
      out.should.not.include('Error downloading Rubygem specification')
    end

    it 'notifies the user when getting the spec index fails' do
      error = Gem::RemoteFetcher::FetchError.new('no host', 'bad url')
      wrapper_error = stub(:error => error)
      response = [[], [wrapper_error]]
      Gem::SpecFetcher.any_instance.stubs(:available_specs).returns(response)

      @cache.download_and_cache_specs
      @cache.specs.should.be.empty?
      UI_OUT.string.should.include('Downloading Rubygem specification index...')
      UI_OUT.string.should.include('Error downloading Rubygem specification')
    end
  end
end
