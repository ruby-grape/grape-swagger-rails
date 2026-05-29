require 'spec_helper'

describe Danger::Toc::MarkdownFile do
  describe 'with a single section' do
    let(:filename) { File.expand_path('../fixtures/markdown_file/one_section.md', __dir__) }
    subject do
      Danger::Toc::MarkdownFile.new(filename)
    end
    it 'exists?' do
      expect(subject.exists?).to be true
    end
    it 'has_toc?' do
      expect(subject.has_toc?).to be false
    end
    it 'toc' do
      expect(subject.toc).to be nil
    end
    it 'headers' do
      expect(subject.headers).to eq([{ depth: 0, id: 'what-is-this', text: 'What is This?' }])
    end
    it 'good?' do
      expect(subject.good?).to be false
    end
    it 'bad?' do
      expect(subject.bad?).to be true
    end
  end
end
