# frozen_string_literal: true

require 'sassc'

RSpec.describe 'swagger-ui.css' do # rubocop:disable RSpec/DescribeClass -- Tests a vendored stylesheet.
  let(:css) { File.read(File.expand_path('../../app/assets/stylesheets/grape_swagger_rails/swagger-ui.css', __dir__)) }

  it 'compresses the bundled Swagger UI stylesheet without errors' do
    expect { SassC::Engine.new(css, style: :compressed).render }.not_to raise_error
  end
end
