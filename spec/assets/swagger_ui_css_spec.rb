# frozen_string_literal: true

RSpec.describe 'swagger-ui.css' do # rubocop:disable RSpec/DescribeClass -- Checks a vendored asset.
  let(:css) { File.read(File.expand_path('../../app/assets/stylesheets/grape_swagger_rails/swagger-ui.css', __dir__)) }

  # sassc (libsass) evaluates lower-case min() and max() as Sass functions and raises
  # "Incompatible units" on values such as min(60vh,800px) when a host app compresses CSS with it.
  it 'has no lower-case min() or max() calls that libsass would evaluate' do
    expect(css.scan(/(?<![\w-])(?:min|max)\([^)]*\)/)).to be_empty
  end
end
