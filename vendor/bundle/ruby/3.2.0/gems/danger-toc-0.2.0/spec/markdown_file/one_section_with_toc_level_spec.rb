require 'spec_helper'

describe Danger::Toc::MarkdownFile do
  describe 'one section that is not at the root level' do
    let(:filename) { File.expand_path('../fixtures/markdown_file/one_section_with_toc_level.md', __dir__) }
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
      expect(subject.toc).to eq(['- [What is This?](#what-is-this)'])
    end
    it 'headers' do
      expect(subject.headers).to eq([{ depth: 0, id: 'what-is-this', text: 'What is This?' }])
    end
    it 'good?' do
      expect(subject.good?).to be true
    end
    it 'bad?' do
      expect(subject.bad?).to be false
    end
  end
end
