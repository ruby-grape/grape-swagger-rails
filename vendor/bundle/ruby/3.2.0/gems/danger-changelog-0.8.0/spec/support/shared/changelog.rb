[
  Danger::Changelog::ChangelogHeaderLine,
  Danger::Changelog::ChangelogPlaceholderLine,
  Danger::Changelog::ChangelogEntryLine
].each do |klass|
  desc = ActiveSupport::Inflector.titleize(klass.name.split(':').last).downcase

  RSpec.shared_examples "validates as #{desc}" do |line|
    describe line do
      it 'correctly' do
        expect(klass.validates_as_changelog_line?(line)).to be true
      end
    end
  end

  RSpec.shared_examples "does not validate as #{desc}" do |line|
    describe line do
      it 'correctly' do
        expect(klass.validates_as_changelog_line?(line)).to be false
      end
    end
  end

  RSpec.shared_examples "valid #{desc}" do |line|
    describe line do
      subject { klass.new(line) }
      it 'is valid' do
        expect(subject.valid?).to be true
      end
    end
  end

  RSpec.shared_examples "invalid #{desc}" do |line|
    describe line do
      subject { klass.new(line) }
      it 'is valid' do
        expect(subject.valid?).to be false
      end
    end
  end
end
