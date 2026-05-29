require File.expand_path('spec_helper', __dir__)

describe Danger::Toc::Constructors do
  describe '.get' do
    it 'should return constructor for kramdown' do
      expect(
        described_class.get(:kramdown)
      ).to eq(Danger::Toc::Constructors::KramdownConstructor)
    end

    it 'should return constructor for github' do
      expect(
        described_class.get(:github)
      ).to eq(Danger::Toc::Constructors::GithubConstructor)
    end

    it 'should return error if not found constructor' do
      expect do
        described_class.get :unknown
      end.to raise_error(NameError)
    end
  end
end
