# frozen_string_literal: true

require 'open3'
require 'tmpdir'
require 'fileutils'

RSpec.describe 'script/update_changelog' do # rubocop:disable RSpec/DescribeClass -- Tests the executable's public interface.
  let(:script) { File.expand_path('../../script/update_changelog', __dir__) }
  let(:changelog) { "### Next Release\n\n* Your contribution here.\n" }
  let(:root) { Dir.mktmpdir }
  let(:path) { File.join(root, 'CHANGELOG.md') }

  let(:environment) do
    {
      'PR_NUMBER' => '183',
      'PR_URL' => 'https://github.com/ruby-grape/grape-swagger-rails/pull/183',
      'PR_AUTHOR' => 'github-actions[bot]',
      'PR_AUTHOR_URL' => 'https://github.com/apps/github-actions',
      'PR_TITLE' => 'Bump Swagger UI'
    }
  end

  around do |example|
    File.write(path, changelog)
    example.run
  ensure
    FileUtils.remove_entry(root)
  end

  def update_changelog
    Open3.capture3(environment.merge('CHANGELOG_PATH' => path), RbConfig.ruby, script)
  end

  it 'preserves bot attribution and leaves existing entries unchanged on subsequent runs' do
    _, stderr, status = update_changelog
    expect(status.success?).to be(true), stderr
    updated = File.read(path)
    expect(updated).to include(' - [@github-actions[bot]](https://github.com/apps/github-actions).')
    expect(update_changelog.last.success?).to be(true)
    expect(File.read(path)).to eq(updated)
  end

  context 'with an existing hand-edited entry' do
    let(:changelog) do
      "### Next Release\n\n" \
        '* [#183](https://github.com/ruby-grape/grape-swagger-rails/pull/183): ' \
        "Custom title - [@dblock](https://github.com/dblock).\n" \
        "* Your contribution here.\n"
    end

    it 'does not rewrite the entry' do
      expect(update_changelog.last.success?).to be(true)
      expect(File.read(path)).to eq(changelog)
    end
  end
end
