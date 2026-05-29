require 'spec_helper'

describe Danger::Toc::MarkdownFile do
  describe 'with a underscore in section name' do
    let(:filename) do
      File.expand_path('../fixtures/markdown_file/one_section_with_underscore_in_name.md', __dir__)
    end

    subject do
      Danger::Toc::MarkdownFile.new(filename)
    end

    it 'exists?' do
      expect(subject.exists?).to be true
    end
    it 'has_toc?' do
      expect(subject.has_toc?).to be true
    end
    it 'toc' do
      expect(subject.toc).to eq(['- [What_is_this?](#what_is_this)'])
    end
    it 'headers' do
      expect(subject.headers).to eq([{ depth: 0, id: 'what_is_this', text: 'What_is_this?' }])
    end
    it 'good?' do
      expect(subject.good?).to be true
    end
    it 'bad?' do
      expect(subject.bad?).to be false
    end
  end
end
