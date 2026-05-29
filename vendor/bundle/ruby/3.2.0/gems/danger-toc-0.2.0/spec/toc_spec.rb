require File.expand_path('spec_helper', __dir__)

describe Danger::Toc do
  after(:each) do
    Danger::Toc::Config.reset
  end

  it 'is a Danger plugin' do
    expect(Danger::DangerToc.new(nil)).to be_a Danger::Plugin
  end

  describe 'with Dangerfile' do
    let(:filename) { File.expand_path('fixtures/markdown_file/one_section_with_toc.md', __dir__) }
    let(:dangerfile) { testing_dangerfile }
    let(:toc) do
      dangerfile.toc.files = [filename]
      dangerfile.toc
    end
    let(:status_report) { toc.status_report }

    context 'toc_changes?' do
      it 'should find modified files' do
        allow(toc.git).to receive(:modified_files).and_return([filename])
        allow(toc.git).to receive(:added_files).and_return([])

        expect(toc).to be_toc_changes
      end

      it 'should find added files' do
        allow(toc.git).to receive(:modified_files).and_return([])
        allow(toc.git).to receive(:added_files).and_return([filename])

        expect(toc).to be_toc_changes
      end

      it 'should not found changed files' do
        allow(toc.git).to receive(:modified_files).and_return([])
        allow(toc.git).to receive(:added_files).and_return([])

        expect(toc).not_to be_toc_changes
      end
    end

    context 'is_toc_correct?' do
      subject do
        toc.is_toc_correct?
      end

      context 'without a file' do
        let(:filename) { 'does-not-exist' }
        it 'complains' do
          expect(subject).to be false
          expect(status_report[:errors]).to eq ['The does-not-exist file does not exist.']
        end
      end

      context 'with changes' do
        before do
          allow(toc.git).to receive(:modified_files).and_return([filename])
          allow(toc.git).to receive(:added_files).and_return([])
        end

        it 'has no complaints' do
          expect(subject).to be true
          expect(status_report[:errors]).to eq []
          expect(status_report[:warnings]).to eq []
          expect(status_report[:markdowns]).to eq []
        end
      end

      context 'with missing TOC' do
        let(:filename) { File.expand_path('fixtures/markdown_file/one_section.md', __dir__) }
        it 'reports errors' do
          expect(subject).to be false
          expect(status_report[:errors]).to eq ["The #{filename} file is missing a TOC."]
          expect(status_report[:warnings]).to eq []
          expect(status_report[:markdowns].map(&:message)).to eq [<<-MARKDOWN
Here's the expected TOC for #{filename}:

```markdown
# Table of Contents

- [What is This?](#what-is-this)
```
          MARKDOWN
]
        end
      end

      context 'with invalid TOC' do
        let(:filename) { File.expand_path('fixtures/markdown_file/one_section_with_invalid_toc.md', __dir__) }
        it 'reports errors' do
          expect(subject).to be false
          expect(status_report[:errors]).to eq ["The TOC found in #{filename} doesn't match the sections of the file."]
          expect(status_report[:warnings]).to eq []
          expect(status_report[:markdowns].map(&:message)).to eq [<<-MARKDOWN
Here's the expected TOC for #{filename}:

```markdown
# Table of Contents

- [What is This?](#what-is-this)
```
          MARKDOWN
]
        end
      end

      context 'with a custom toc header' do
        before do
          Danger::Toc.config.header = 'Custom TOC'
        end

        context 'with missing TOC' do
          let(:filename) { File.expand_path('fixtures/markdown_file/one_section.md', __dir__) }
          it 'reports errors' do
            expect(subject).to be false
            expect(status_report[:markdowns].first.message).to include "\n# Custom TOC\n"
          end
        end

        context 'with a custom TOC' do
          let(:filename) { File.expand_path('fixtures/markdown_file/one_section_with_custom_toc.md', __dir__) }
          it 'has no complaints' do
            expect(subject).to be true
            expect(status_report[:errors]).to eq []
            expect(status_report[:warnings]).to eq []
            expect(status_report[:markdowns]).to eq []
          end
        end
      end
    end
  end
end
