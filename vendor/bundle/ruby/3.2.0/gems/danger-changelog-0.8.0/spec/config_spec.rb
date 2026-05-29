require 'spec_helper'

describe Danger::Changelog::Config do
  describe 'placeholder_line' do
    context 'an instance of a dangerfile' do
      let(:dangerfile) { testing_dangerfile }
      let(:changelog) { dangerfile.changelog }

      it 'defaults placeholder_line' do
        expect(changelog.placeholder_line).to eq "* Your contribution here.\n"
      end
    end

    context 'when without markdown star' do
      before do
        Danger::Changelog.config.placeholder_line = "Nothing yet.\n"
      end

      it 'adds missing star and saves configuration' do
        expect(Danger::Changelog.config.placeholder_line).to eq "* Nothing yet.\n"
      end
    end

    context 'when without trailing newline' do
      before do
        Danger::Changelog.config.placeholder_line = '* Nothing yet.'
      end

      it 'adds missing trailing newline and saves configuration' do
        expect(Danger::Changelog.config.placeholder_line).to eq "* Nothing yet.\n"
      end
    end

    context 'when valid' do
      before do
        Danger::Changelog.config.placeholder_line = "* Nothing yet.\n"
      end

      it 'saves configuration' do
        expect(Danger::Changelog.config.placeholder_line).to eq "* Nothing yet.\n"
      end
    end
  end

  describe 'format' do
    it 'default' do
      expect(Danger::Changelog.config.format).to eq :intridea
    end

    it 'with an invalid format' do
      expect { Danger::Changelog.config.format = :foobar }.to raise_error ArgumentError, 'Invalid format: foobar'
    end

    it 'with a string' do
      expect { Danger::Changelog.config.format = 'intridea' }.not_to raise_error
    end

    it 'with a symbol' do
      expect { Danger::Changelog.config.format = :intridea }.not_to raise_error
    end

    Danger::Changelog::Parsers::FORMATS.each_pair do |format, parser|
      context format do
        before do
          Danger::Changelog.config.format = format
        end

        it 'sets format' do
          expect(Danger::Changelog.config.format).to eq format
        end

        it 'creates parser' do
          expect(Danger::Changelog.config.parser).to be_a parser
        end
      end
    end
  end

  describe 'ignore_files' do
    it 'default' do
      expect(Danger::Changelog.config.ignore_files).to eq(['README.md'])
    end

    context 'with a file name' do
      before do
        Danger::Changelog.config.ignore_files = 'WHATEVER.md'
      end

      it 'transforms it into an array' do
        expect(Danger::Changelog.config.ignore_files).to eq(['WHATEVER.md'])
      end
    end

    context 'with multiple names' do
      before do
        Danger::Changelog.config.ignore_files = ['WHATEVER.md', /\*.md$/]
      end

      it 'transforms it into an array' do
        expect(Danger::Changelog.config.ignore_files).to eq(['WHATEVER.md', /\*.md$/])
      end
    end
  end
end
