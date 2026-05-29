require 'spec_helper'
require 'tempfile'

describe Danger::Changelog::PRMetadata do
  describe '.from_github_plugin' do
    context 'when github is nil' do
      it 'returns nil' do
        expect(described_class.from_github_plugin(nil)).to be_nil
      end
    end

    context 'when github has no pr_json' do
      let(:github) { instance_double(Danger::DangerfileGitHubPlugin, pr_json: nil) }

      it 'returns nil' do
        expect(described_class.from_github_plugin(github)).to be_nil
      end
    end

    context 'when github has pr_json' do
      subject(:metadata) { described_class.from_github_plugin(github) }

      let(:github) do
        instance_double(
          Danger::DangerfileGitHubPlugin,
          pr_json: { 'number' => 123, 'html_url' => 'https://github.com/org/repo/pull/123' },
          pr_title: 'Add feature',
          pr_author: 'dblock'
        )
      end

      it 'creates metadata from github plugin' do
        expect(metadata.pr_json).to eq('number' => 123, 'html_url' => 'https://github.com/org/repo/pull/123')
        expect(metadata.pr_title).to eq 'Add feature'
        expect(metadata.pr_author).to eq 'dblock'
      end
    end

    context 'when github plugin raises Octokit::Error' do
      let(:github) do
        instance_double(Danger::DangerfileGitHubPlugin)
      end

      [Octokit::Unauthorized, Octokit::TooManyRequests, Octokit::Forbidden].each do |error_class|
        context "with #{error_class}" do
          before do
            allow(github).to receive(:pr_json).and_raise(error_class.new)
          end

          it 'returns nil to allow fallback' do
            expect(described_class.from_github_plugin(github)).to be_nil
          end
        end
      end
    end
  end

  describe '.from_event_file' do
    context 'when path is nil' do
      it 'returns nil' do
        expect(described_class.from_event_file(nil)).to be_nil
      end
    end

    context 'when file does not exist' do
      it 'returns nil' do
        expect(described_class.from_event_file('/nonexistent/path.json')).to be_nil
      end
    end

    context 'when file contains pull_request event' do
      subject(:metadata) { described_class.from_event_file(event_file.path) }

      let(:event_file) { Tempfile.new(['github_event', '.json']) }
      let(:event_data) do
        {
          'pull_request' => {
            'number' => 456,
            'html_url' => 'https://github.com/org/repo/pull/456',
            'title' => 'Fix bug',
            'user' => { 'login' => 'contributor' }
          }
        }
      end

      before do
        event_file.write(JSON.generate(event_data))
        event_file.close
      end

      after { event_file.unlink }

      it 'creates metadata from event file' do
        expect(metadata.pr_json).to eq event_data['pull_request']
        expect(metadata.pr_title).to eq 'Fix bug'
        expect(metadata.pr_author).to eq 'contributor'
      end
    end

    context 'when file contains non-PR event' do
      let(:event_file) { Tempfile.new(['github_event', '.json']) }
      let(:event_data) { { 'push' => { 'ref' => 'refs/heads/main' } } }

      before do
        event_file.write(JSON.generate(event_data))
        event_file.close
      end

      after { event_file.unlink }

      it 'returns nil' do
        expect(described_class.from_event_file(event_file.path)).to be_nil
      end
    end
  end

  describe '.fallback' do
    subject(:metadata) { described_class.fallback }

    it 'returns metadata with example values' do
      expect(metadata.pr_json).to eq('number' => 123, 'html_url' => 'https://github.com/org/repo/pull/123')
      expect(metadata.pr_title).to eq 'Your contribution'
      expect(metadata.pr_author).to eq 'username'
    end
  end
end
