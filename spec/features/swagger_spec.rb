require 'spec_helper'

describe 'Swagger' do
  context 'swaggerUi' do
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
  context "#options.headers" do
    before do
      GrapeSwaggerRails.options.headers['X-Test-Header'] = 'Test Value'
      visit '/swagger'
    end
    after do
      GrapeSwaggerRails.options.headers = {}
    end
    it 'adds headers' do
      find('#endpointListTogger_headers', visible: true).click
      find('a[href="#!/headers/GET_api_headers_format"]', visible: true).click
      find('.sandbox_header input[name="commit"]', visible: true).click
      expect(page).to have_css "span.attribute", text: 'X-Test-Header'
      expect(page).to have_css "span.string", text: 'Test Value'
    end
  end
end
