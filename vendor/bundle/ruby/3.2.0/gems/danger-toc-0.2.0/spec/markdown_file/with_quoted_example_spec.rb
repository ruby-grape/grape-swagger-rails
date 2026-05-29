require 'spec_helper'

describe Danger::Toc::MarkdownFile do
  describe 'with a code example' do
    let(:filename) { File.expand_path('../fixtures/markdown_file/with_quoted_example.md', __dir__) }
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
      expect(subject.toc).to eq(['- [Example](#example)', '- [Conclusion](#conclusion)'])
    end
    it 'headers' do
      expect(subject.headers).to eq(
        [
          { depth: 0, id: 'example', text: 'Example' },
          { depth: 0, id: 'conclusion', text: 'Conclusion' }
        ]
      )
    end
    it 'good?' do
      expect(subject.good?).to be true
    end
    it 'bad?' do
      expect(subject.bad?).to be false
    end
  end
end
