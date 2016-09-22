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

    it 'evaluates config options correctly' do
      visit '/swagger'
      page_options_json = page.evaluate_script("$('html').data('swagger-options')").to_json
      expect(page_options_json).to eq(@options.marshal_dump.to_json)
    end

    context '#headers' do
      before do
        GrapeSwaggerRails.options.headers['X-Test-Header'] = 'Test Value'
        GrapeSwaggerRails.options.headers['X-Another-Header'] = 'Another Value'
        visit '/swagger'
      end
      it 'adds headers' do
        headers = page.evaluate_script('swaggerUi.api.clientAuthorizations')['authz']
        expect(headers.select { |key| key.to_s.match(/^header/) }).not_to be_blank
        expect(headers.fetch('header_0', {}).fetch('name', {})).to eq GrapeSwaggerRails.options.headers.keys.first
        find('#endpointListTogger_headers', visible: true).click
        first('span[class="http_method"] a', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css 'span.hljs-attr', text: 'X-Test-Header'
        expect(page).to have_css 'span.hljs-string', text: 'Test Value'
      end
      it 'supports multiple headers' do
        find('#endpointListTogger_headers', visible: true).click
        first('span[class="http_method"] a', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css 'span.hljs-attr', text: 'X-Test-Header'
        expect(page).to have_css 'span.hljs-string', text: 'Test Value'
        expect(page).to have_css 'span.hljs-attr', text: 'X-Another-Header'
        expect(page).to have_css 'span.hljs-string', text: 'Another Value'
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
        first('span[class="http_method"] a', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css 'span.hljs-attr', text: 'Authorization'
        expect(page).to have_css 'span.hljs-string', text: "Basic #{Base64.encode64('username:password').strip}"
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
        first('span[class="http_method"] a', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css 'span.hljs-attr', text: 'Authorization'
        expect(page).to have_css 'span.hljs-string', text: 'Bearer token'
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
        first('span[class="http_method"] a', visible: true).click
        click_button 'Try it out!'
        expect(page).to have_css 'span.hljs-attr', text: 'api_token'
        expect(page).to have_css 'span.hljs-string', text: 'dummy'
      end
    end
    context '#before_filter' do
      before do
        allow(ActiveSupport::Deprecation).to receive(:warn)
      end
      it 'throws deprecation warning' do
        GrapeSwaggerRails.options.before_filter { true }

        expect(ActiveSupport::Deprecation).to have_received(:warn).with('This option is deprecated ' \
          'and going to be removed in 1.0.0. Please use `before_action` instead')
      end
    end
    context '#before_action' do
      before do
        GrapeSwaggerRails.options.before_action do |_request|
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
    context '#supported_submit_methods' do
      context 'set all operations' do
        before do
          GrapeSwaggerRails.options.supported_submit_methods = %w(get post put delete patch)
          visit '/swagger'
        end
        it 'sets SwaggerUI supportedSubmitMethods with all operations' do
          expect(page.evaluate_script('window.swaggerUi.options.supportedSubmitMethods.length')).to eq 5
          find('#endpointListTogger_params', visible: true).click
          first('span[class="http_method"] a', visible: true).click
          expect(page).to have_button('Try it out!', disabled: false)
        end
      end
      context 'set some operations' do
        before do
          GrapeSwaggerRails.options.supported_submit_methods = ['post']
          visit '/swagger'
        end
        it 'sets SwaggerUI supportedSubmitMethods with some operations' do
          expect(page.evaluate_script('window.swaggerUi.options.supportedSubmitMethods.length')).to eq 1
          find('#endpointListTogger_params', visible: true).click
          first('span[class="http_method"] a', visible: true).click
          expect(page).not_to have_button('Try it out!')
        end
      end
      context 'set nil' do
        before do
          GrapeSwaggerRails.options.supported_submit_methods = nil
          visit '/swagger'
        end
        it 'clears SwaggerUI supportedSubmitMethods' do
          expect(page.evaluate_script('window.swaggerUi.options.supportedSubmitMethods.length')).to eq 0
          find('#endpointListTogger_params', visible: true).click
          first('span[class="http_method"] a', visible: true).click
          expect(page).not_to have_button('Try it out!')
        end
      end
      context 'not set' do
        before do
          visit '/swagger'
        end
        it 'defaults SwaggerUI supportedSubmitMethods' do
          expect(page.evaluate_script('window.swaggerUi.options.supportedSubmitMethods.length')).to eq 5
          find('#endpointListTogger_params', visible: true).click
          first('span[class="http_method"] a', visible: true).click
          expect(page).to have_button('Try it out!', disabled: false)
        end
      end
    end
    context '#validator_url' do
      context 'set null' do
        before do
          GrapeSwaggerRails.options.validator_url = nil
          visit '/swagger'
        end
        it 'sets SwaggerUI validatorUrl to null' do
          expect(page.evaluate_script('window.swaggerUi.options.validatorUrl === null && '\
            'typeof window.swaggerUi.options.validatorUrl === "object"')).to be true
        end
      end
      context 'set a url' do
        before do
          GrapeSwaggerRails.options.validator_url = 'http://www.example.com/'
          visit '/swagger'
        end
        it 'sets SwaggerUI validatorUrl to expected url' do
          expect(page.evaluate_script('window.swaggerUi.options.validatorUrl === "http://www.example.com/"')).to be true
        end
      end
      context 'not set' do
        before do
          visit '/swagger'
        end
        it 'defaults SwaggerUI validatorUrl' do
          expect(page.evaluate_script('window.swaggerUi.options.validatorUrl === undefined && '\
            'typeof window.swaggerUi.options.validatorUrl === "undefined"')).to be true
        end
      end
    end
    after do
      GrapeSwaggerRails.options = @options
    end
  end
end
