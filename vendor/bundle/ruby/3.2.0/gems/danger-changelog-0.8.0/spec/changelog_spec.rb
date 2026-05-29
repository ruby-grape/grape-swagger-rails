require 'spec_helper'

describe Danger::Changelog do
  let(:dangerfile) { testing_dangerfile }
  let(:changelog) {  dangerfile.changelog }
  let(:status_report) { changelog.status_report }

  describe 'in a PR' do
    before do
      changelog.env.request_source.pr_json = {
        'number' => 123,
        'title' => 'being dangerous',
        'html_url' => 'https://github.com/dblock/danger-changelog/pull/123',
        'user' => {
          'login' => 'dblock'
        }
      }
    end

    context 'check!' do
      subject do
        changelog.check!
      end

      context 'without CHANGELOG changes' do
        before do
          allow(changelog.git).to receive_messages(modified_files: ['some-file.txt'], added_files: ['some-file.txt'])
        end

        it 'complains when no CHANGELOG can be found' do
          expect(subject).to be false
          expect(status_report[:errors]).to eq []
          expect(status_report[:warnings]).to eq ["Unless you're refactoring existing code or improving documentation, please update CHANGELOG.md."]
          expect(status_report[:markdowns].map(&:message).first).to include("Here's an example of a CHANGELOG.md entry:")
          expect(status_report[:markdowns].map(&:message).first).to match(%r{\* \[#\d+\]\(https://github\.com/.+/pull/\d+\): .+ - \[@.+\]\(https://github\.com/.+\)\.})
        end
      end

      context 'with CHANGELOG changes' do
        before do
          allow(changelog.git).to receive_messages(modified_files: [changelog.filename], added_files: [])
        end

        it 'has no complaints' do
          expect(subject).to be true
          expect(status_report[:errors]).to eq []
          expect(status_report[:warnings]).to eq []
          expect(status_report[:markdowns]).to eq []
        end
      end
    end

    context 'have_you_updated_changelog?' do
      subject do
        changelog.have_you_updated_changelog?
      end

      context 'without CHANGELOG changes' do
        context 'when something was modified' do
          before do
            allow(changelog.git).to receive_messages(modified_files: ['some-file.txt'], added_files: ['another-file.txt'])
          end

          it 'complains when no CHANGELOG can be found' do
            expect(subject).to be false
            expect(status_report[:errors]).to eq []
            expect(status_report[:warnings]).to eq ["Unless you're refactoring existing code or improving documentation, please update #{changelog.filename}."]
            expect(status_report[:markdowns].map(&:message).first).to include("Here's an example of a #{changelog.filename} entry:")
            expect(status_report[:markdowns].map(&:message).first).to match(%r{\* \[#\d+\]\(https://github\.com/.+/pull/\d+\): .+ - \[@.+\]\(https://github\.com/.+\)\.})
          end
        end

        context 'with a README.md' do
          before do
            allow(changelog.git).to receive_messages(modified_files: ['README.md'], added_files: [])
          end

          it 'has no complaints' do
            expect(subject).to be true
            expect(status_report[:errors]).to eq []
            expect(status_report[:warnings]).to eq []
            expect(status_report[:markdowns]).to eq []
          end
        end

        context 'with files being ignored' do
          context 'name' do
            before do
              changelog.ignore_files = ['WHATEVER.md']
              allow(changelog.git).to receive_messages(modified_files: ['WHATEVER.md'], added_files: [])
            end

            it 'has no complaints' do
              expect(subject).to be true
              expect(status_report[:errors]).to eq []
              expect(status_report[:warnings]).to eq []
              expect(status_report[:markdowns]).to eq []
            end
          end

          context 'mixed' do
            before do
              changelog.ignore_files = ['WHATEVER.md', /\.txt$/]
              allow(changelog.git).to receive_messages(modified_files: ['WHATEVER.md'], added_files: ['one.txt', 'two.txt'])
            end

            it 'has no complaints' do
              expect(subject).to be true
              expect(status_report[:errors]).to eq []
              expect(status_report[:warnings]).to eq []
              expect(status_report[:markdowns]).to eq []
            end
          end
        end
      end

      context 'with a new CHANGELOG' do
        before do
          allow(changelog.git).to receive_messages(modified_files: [], added_files: [changelog.filename])
        end

        it 'has no complaints' do
          expect(subject).to be true
          expect(status_report[:errors]).to eq []
          expect(status_report[:warnings]).to eq []
          expect(status_report[:markdowns]).to eq []
        end
      end

      context 'with CHANGELOG changes' do
        before do
          allow(changelog.git).to receive_messages(modified_files: [changelog.filename], added_files: [])
        end

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
