require File.expand_path('spec_helper', __dir__)

describe Danger::Toc::Config do
  after(:each) do
    described_class.reset
  end

  describe 'configure' do
    describe 'files' do
      context 'default' do
        it 'assumes README.md' do
          expect(Danger::Toc.config.files).to eq ['README.md']
        end
      end
      context 'custom value' do
        before do
          Danger::Toc.config.files = ['README.md', 'SOMETHING.md']
        end

        it 'is set' do
          expect(Danger::Toc.config.files).to eq ['README.md', 'SOMETHING.md']
        end
      end
    end
    describe 'header' do
      context 'default' do
        it 'assumes Table of Contents' do
          expect(Danger::Toc.config.header).to eq 'Table of Contents'
        end
      end
      context 'custom value' do
        before do
          Danger::Toc.config.header = 'Custom TOC'
        end

        it 'is set' do
          expect(Danger::Toc.config.header).to eq 'Custom TOC'
        end
      end
    end

    describe 'format' do
      context 'default' do
        it 'assumes github' do
          expect(Danger::Toc.config.format).to eq(:github)
        end
      end

      context 'custom value' do
        before do
          Danger::Toc.config.format = :kramdown
        end

        it 'is set' do
          expect(Danger::Toc.config.format).to eq(:kramdown)
        end
      end
    end
  end
end
