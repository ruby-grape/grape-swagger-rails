require 'spec_helper'

describe 'Swagger' do
  before do
    visit '/swagger'
  end
  it 'loads foos resource' do
    expect(page).to have_css "li#resource_foos"
  end
  it 'loads Swagger UI' do
    expect(page.evaluate_script('window.swaggerUi != null')).to be true
  end
end
