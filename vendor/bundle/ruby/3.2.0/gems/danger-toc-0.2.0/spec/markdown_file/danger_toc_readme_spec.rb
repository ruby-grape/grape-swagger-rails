require 'spec_helper'

describe Danger::Toc::MarkdownFile do
  describe 'danger-toc README' do
    let(:filename) { File.expand_path('../../README.md', __dir__) }
    subject do
      Danger::Toc::MarkdownFile.new(filename)
    end
    it 'exists?' do
      expect(subject.exists?).to be true
    end
    it 'has_toc?' do
      expect(subject.has_toc?).to be true
    end
    it 'good?' do
      expect(subject.good?).to be true
    end
  end
end
