require 'spec_helper'

describe 'Swagger' do
  context 'swaggerUi' do
    before do
      visit '/swagger'
    end
    it 'loads foos resource' do
      expect(page).to have_css 'li#resource_foos'
    end
    it 'loads Swagger UI' do
      expect(page.evaluate_script('window.swaggerUi != null')).to be true
    end
  end
  context '#options' do
    before do
      @options = GrapeSwaggerRails.options.dup
    end
    context '#headers' do
      before do
        GrapeSwaggerRails.options.headers['X-Test-Header'] = 'Test Value'
        GrapeSwaggerRails.options.headers['X-Another-Header'] = 'Another Value'
        visit '/swagger'
      end
      it 'adds headers' do
        find('#endpointListTogger_headers', visible: true).click
        first('a[href="#!/headers/GET_api_headers_format"]', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css 'span.attribute', text: 'X-Test-Header'
        expect(page).to have_css 'span.string', text: 'Test Value'
      end
      it 'supports multiple headers' do
        find('#endpointListTogger_headers', visible: true).click
        first('a[href="#!/headers/GET_api_headers_format"]', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css 'span.attribute', text: 'X-Test-Header'
        expect(page).to have_css 'span.string', text: 'Test Value'
        expect(page).to have_css 'span.attribute', text: 'X-Another-Header'
        expect(page).to have_css 'span.string', text: 'Another Value'
      end
    end
    context '#api_auth:basic' do
      before do
        GrapeSwaggerRails.options.api_auth = 'basic'
        GrapeSwaggerRails.options.api_key_name = 'Authorization'
        GrapeSwaggerRails.options.api_key_type = 'header'
        visit '/swagger'
      end
      it 'adds an Authorization header' do
        page.execute_script("$('#input_apiKey').val('username:password')")
        page.execute_script("$('#input_apiKey').trigger('change')")
        find('#endpointListTogger_headers', visible: true).click
        first('a[href="#!/headers/GET_api_headers_format"]', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css 'span.attribute', text: 'Authorization'
        expect(page).to have_css 'span.string', text: "Basic #{Base64.encode64('username:password').strip}"
      end
    end
    context '#api_auth:bearer' do
      before do
        GrapeSwaggerRails.options.api_auth = 'bearer'
        GrapeSwaggerRails.options.api_key_name = 'Authorization'
        GrapeSwaggerRails.options.api_key_type = 'header'
        visit '/swagger'
      end
      it 'adds an Authorization header' do
        page.execute_script("$('#input_apiKey').val('token')")
        page.execute_script("$('#input_apiKey').trigger('change')")
        find('#endpointListTogger_headers', visible: true).click
        first('a[href="#!/headers/GET_api_headers_format"]', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css 'span.attribute', text: 'Authorization'
        expect(page).to have_css 'span.string', text: 'Bearer token'
      end
    end
    context '#api_auth:token' do
      before do
        GrapeSwaggerRails.options.api_key_name = 'api_token'
        GrapeSwaggerRails.options.api_key_type = 'query'
        visit '/swagger'
      end
      it 'adds an api_token query parameter' do
        page.execute_script("$('#input_apiKey').val('dummy')")
        page.execute_script("$('#input_apiKey').trigger('change')")
        find('#endpointListTogger_params', visible: true).click
        first('a[href="#!/params/GET_api_params_format"]', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css 'span.attribute', text: 'api_token'
        expect(page).to have_css 'span.string', text: 'dummy'
      end
    end
    context '#before_filter' do
      before do
        GrapeSwaggerRails.options.before_filter do |_request|
          flash[:error] = 'Unauthorized Access'
          redirect_to '/'
          false
        end
        visit '/swagger'
      end
      it 'denies access' do
        expect(current_path).to eq '/'
        expect(page).to have_content 'Unauthorized Access'
      end
    end
    context '#app_name' do
      context 'set' do
        before do
          GrapeSwaggerRails.options.app_name = 'Test App'
          visit '/swagger'
        end
        it 'sets page title' do
          expect(page.title).to eq 'Test App'
        end
      end
      context 'not set' do
        before do
          visit '/swagger'
        end
        it 'defaults page title' do
          expect(page.title).to eq 'Swagger'
        end
      end
    end
    context '#doc_expansion' do
      context 'set list' do
        before do
          GrapeSwaggerRails.options.doc_expansion = 'list'
          visit '/swagger'
        end
        it 'sets SwaggerUI docExpansion with list' do
          expect(page.evaluate_script('window.swaggerUi.options.docExpansion == "list"')).to be true
        end
      end
      context 'set full' do
        before do
          GrapeSwaggerRails.options.doc_expansion = 'full'
          visit '/swagger'
        end
        it 'sets SwaggerUI docExpansion with full' do
          expect(page.evaluate_script('window.swaggerUi.options.docExpansion == "full"')).to be true
        end
      end
      context 'not set' do
        before do
          visit '/swagger'
        end
        it 'defaults SwaggerUI docExpansion' do
          expect(page.evaluate_script('window.swaggerUi.options.docExpansion == "none"')).to be true
        end
      end
    end
    after do
      GrapeSwaggerRails.options = @options
    end
  end
end
