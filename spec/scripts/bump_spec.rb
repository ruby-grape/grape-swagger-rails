# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'open3'
require 'tmpdir'

RSpec.describe 'bin/bump' do # rubocop:disable RSpec/DescribeClass -- Tests the executable's public interface.
  let(:root) { Dir.mktmpdir }
  let(:history) { "### 1.0.10 (2026/09/22)\n\n* Previous release.\n" }
  let(:items) { "* First change.\n  More details.\n\n* Second change.\n* Your contribution here.\n" }
  let(:changelog) { "### Next Release\n\n#{items}\n#{history}" }
  let(:version_source) { "module GrapeSwaggerRails\n  VERSION = '1.0.10'\n  SWAGGER_UI_VERSION = '5.33.0'\nend\n" }

  around do |example|
    FileUtils.mkdir_p(File.join(root, 'bin'))
    FileUtils.mkdir_p(File.join(root, 'lib/grape-swagger-rails'))
    FileUtils.cp(File.expand_path('../../bin/bump', __dir__), File.join(root, 'bin/bump'))
    File.write(File.join(root, 'CHANGELOG.md'), changelog)
    File.write(File.join(root, 'lib/grape-swagger-rails/version.rb'), version_source)
    example.run
  ensure
    FileUtils.remove_entry(root)
  end

  def bump(*)
    Open3.capture3(RbConfig.ruby, File.join(root, 'bin/bump'), *, chdir: Dir.tmpdir)
  end

  def read_changelog
    File.read(File.join(root, 'CHANGELOG.md'))
  end

  def read_version
    File.read(File.join(root, 'lib/grape-swagger-rails/version.rb'))
  end

  it 'moves all entries, retains their formatting and history, and updates only the gem version' do
    _, stderr, status = bump('1.0.11')
    expect(status.success?).to be(true), stderr
    expect(read_changelog).to eq(
      "### Next Release\n\n* Your contribution here.\n\n" \
      "### 1.0.11 (#{Date.today.strftime('%Y/%m/%d')})\n\n" \
      "* First change.\n  More details.\n\n* Second change.\n\n#{history}"
    )
    expect(read_version).to eq(version_source.sub("VERSION = '1.0.10'", "VERSION = '1.0.11'"))
  end

  it 'rejects missing, malformed, equal, and older versions without changing files' do
    [[], ['oops'], ['1.0.11', 'extra'], ['1.0.10'], ['0.9.0']].each do |args|
      expect(bump(*args).last.success?).to be(false)
      expect(read_changelog).to eq(changelog)
      expect(read_version).to eq(version_source)
    end
  end

  context 'with only the contribution placeholder' do
    let(:items) { "* Your contribution here.\n" }

    it 'rejects an empty release without changing files' do
      expect(bump('1.0.11').last.success?).to be(false)
      expect(read_changelog).to eq(changelog)
      expect(read_version).to eq(version_source)
    end
  end

  context 'without a Next Release section' do
    let(:changelog) { history }

    it 'leaves both files unchanged' do
      expect(bump('1.0.11').last.success?).to be(false)
      expect(read_changelog).to eq(changelog)
      expect(read_version).to eq(version_source)
    end
  end

  context 'with the requested version already in the changelog' do
    let(:history) { "### 1.0.11 (2026/09/22)\n\n* Existing release.\n" }

    it 'rejects the duplicate without changing files' do
      expect(bump('1.0.11').last.success?).to be(false)
      expect(read_changelog).to eq(changelog)
      expect(read_version).to eq(version_source)
    end
  end
end
