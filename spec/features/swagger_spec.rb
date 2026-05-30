# frozen_string_literal: true

describe 'Swagger' do
  def visit_swagger
    visit '/swagger'
    expect(page).to have_css('.swagger-ui')
  end

  def swagger_options_data
    page.evaluate_script('JSON.parse(document.documentElement.dataset.swaggerOptions)')
  end

  def swagger_document
    session = Capybara::Session.new(:rack_test, Rails.application)
    session.visit('/api/swagger_doc')
    JSON.parse(session.html)
  end

  def build_documented_api(swagger_options = {})
    Class.new(Grape::API) do
      prefix 'api'

      desc 'Get health.'
      get '/health' do
        { status: 'ok' }
      end

      add_swagger_documentation(swagger_options)
    end
  end

  def swagger_documentation_route_paths(api)
    api.combined_namespace_routes.fetch('swagger_doc').map(&:path)
  end

  def swagger_configs
    page.evaluate_script(<<~JS)
      (function() {
        var configs = window.ui.getConfigs();

        return {
          docExpansion: configs.docExpansion,
          defaultModelsExpandDepth: configs.defaultModelsExpandDepth,
          displayRequestDuration: configs.displayRequestDuration,
          supportedSubmitMethods: configs.supportedSubmitMethods,
          validatorUrl: configs.validatorUrl,
          validatorType: typeof configs.validatorUrl,
          url: configs.url,
          urls: configs.urls && configs.urls.map(function(entry) {
            return {
              name: entry.name,
              url: entry.url
            };
          })
        };
      })()
    JS
  end

  def theme_state
    page.evaluate_script(<<~JS)
      (function() {
        var toggle = document.getElementById('theme-toggle');

        return {
          theme: document.documentElement.dataset.theme,
          buttonLabel: toggle && toggle.textContent,
          pressed: toggle && toggle.getAttribute('aria-pressed')
        };
      })()
    JS
  end

  def intercepted_request(url)
    page.evaluate_script(<<~JS, url)
      (function(requestUrl) {
        var request = { url: requestUrl, headers: {} };
        return window.ui.getConfigs().requestInterceptor(request);
      })(arguments[0])
    JS
  end

  def intercepted_request_with_headers_object(url)
    page.evaluate_script(<<~JS, url)
      (function(requestUrl) {
        var request = { url: requestUrl, headers: new Headers() };
        request = window.ui.getConfigs().requestInterceptor(request);

        return {
          url: request.url,
          headers: {
            testHeader: request.headers.get('X-Test-Header'),
            anotherHeader: request.headers.get('X-Another-Header'),
            authorization: request.headers.get('Authorization')
          }
        };
      })(arguments[0])
    JS
  end

  def intercepted_request_without_headers(url)
    page.evaluate_script(<<~JS, url)
      (function(requestUrl) {
        var request = { url: requestUrl };
        return window.ui.getConfigs().requestInterceptor(request);
      })(arguments[0])
    JS
  end

  def fill_api_key(value)
    find_by_id('input_apiKey').set(value)
  end

  def open_operation(tag_id, operation_id)
    find("##{tag_id} .expand-operation").click
    find("##{operation_id} .opblock-control-arrow").click
  end

  def execute_operation(operation_id)
    within("##{operation_id}") do
      find('.try-out__btn').click
      find('.execute').click
    end
  end

  def fill_echo_form
    within('#operations-echo-postApiEcho') do
      find('.try-out__btn').click
      find('tr[data-param-name="name"] input').set('Widget')
      find('tr[data-param-name="enabled"] select').find('option', text: 'true').select_option
      find('.execute').click
    end
  end

  it "uses grape-swagger=#{GrapeSwagger::VERSION} grape-swagger-rails=#{GrapeSwaggerRails::VERSION}" do
    expect(GrapeSwagger::VERSION).not_to be_blank
    expect(GrapeSwaggerRails::VERSION).not_to be_blank
  end

  shared_context 'with isolated options' do
    around do |example|
      saved = GrapeSwaggerRails.options
      deep = saved.marshal_dump.transform_values do |v|
        v.dup
      rescue TypeError
        v
      end
      deep[:before_action_proc] = saved.before_action_proc
      example.run
    ensure
      GrapeSwaggerRails.options = GrapeSwaggerRails::Options.new(**deep)
    end
  end

  describe 'hide_documentation_path behavior' do
    it 'hides its own documentation routes by default' do
      api = build_documented_api

      expect(swagger_documentation_route_paths(api)).to be_empty
    end

    it 'includes its own documentation routes when disabled' do
      api = build_documented_api(hide_documentation_path: false)

      expect(swagger_documentation_route_paths(api)).to contain_exactly(
        '/api/swagger_doc(.json)',
        '/api/swagger_doc/:name(.json)'
      )
    end

    it 'does not include swagger_doc paths in the served document' do
      expect(swagger_document.fetch('paths').keys.grep(/swagger_doc/)).to be_empty
    end
  end

  describe 'display[:info_url] option' do
    include_context 'with isolated options'

    it 'shows the info URL link by default' do
      visit_swagger

      expect(page).to have_css('.swagger-ui .info a.link')
    end

    it 'hides the info URL link when disabled' do
      GrapeSwaggerRails.options.display = GrapeSwaggerRails.options.display.merge(info_url: false)
      visit_swagger

      expect(page).to have_no_css('.swagger-ui .info a.link[href="http://localhost:3000/api/swagger_doc"]')
      expect(page).to have_css('.opblock-tag', text: 'foos')
      expect(page).to have_no_css('.opblock-tag, .opblock-summary-path', text: 'swagger_doc')
    end
  end

  describe 'display[:doc_version] option' do
    include_context 'with isolated options'

    it 'shows the document version by default' do
      visit_swagger

      # The VersionStamp component renders info.version outside of .version-stamp
      expect(page).to have_css('.swagger-ui .info small:not(.version-stamp) .version')
    end

    it 'hides the document version when disabled' do
      GrapeSwaggerRails.options.display = GrapeSwaggerRails.options.display.merge(doc_version: false)
      visit_swagger

      # VersionStamp is suppressed, but the OAS badge (.version-stamp) remains
      expect(page).to have_no_css('.swagger-ui .info small:not(.version-stamp) .version')
      expect(page).to have_css('.swagger-ui .info .version-stamp .version', text: 'OAS 2.0')
    end
  end

  describe 'display[:version_stamp] option' do
    include_context 'with isolated options'

    it 'shows the OAS version stamp by default' do
      visit_swagger

      expect(page).to have_css('.swagger-ui .info .version-stamp .version', text: 'OAS 2.0')
    end

    it 'hides the OAS version stamp when disabled' do
      GrapeSwaggerRails.options.display = GrapeSwaggerRails.options.display.merge(version_stamp: false)
      visit_swagger

      expect(page).to have_no_css('.swagger-ui .info .version-stamp')
      # The document version (VersionStamp) remains visible
      expect(page).to have_css('.swagger-ui .info small:not(.version-stamp) .version')
    end
  end

  describe 'display[:clear_button] option' do
    include_context 'with isolated options'

    it 'hides the Clear button by default after Execute' do
      visit_swagger
      open_operation('operations-tag-foos', 'operations-foos-getApiFoos')
      execute_operation('operations-foos-getApiFoos')

      within('#operations-foos-getApiFoos') do
        expect(page).to have_css('.responses-wrapper')
        expect(page).to have_no_css('.btn-clear')
      end
    end

    it 'shows the Clear button when enabled' do
      GrapeSwaggerRails.options.display = GrapeSwaggerRails.options.display.merge(clear_button: true)
      visit_swagger
      open_operation('operations-tag-foos', 'operations-foos-getApiFoos')
      execute_operation('operations-foos-getApiFoos')

      within('#operations-foos-getApiFoos') do
        expect(page).to have_css('.btn-clear', text: 'Clear')
      end
    end
  end

  describe 'same-session deep link navigation' do
    # Regression tests for: navigating to a Swagger deep-link URL in the same
    # tab/session should expand the target operation without a full page refresh.

    it 'expands the target operation when navigating to a deep link URL in the same tab' do
      visit_swagger
      expect(page).to have_css('.opblock-tag', text: 'foos')
      expect(page).to have_no_css('#operations-foos-getApiFoos .opblock-summary')

      # Simulate pasting/navigating to a deep-link URL in the same session (same tab)
      # This mimics a user copying an operation URL and opening it in the address bar
      # without opening a new tab.
      visit '/swagger#/foos/getApiFoos'

      expect(page).to have_css('.swagger-ui', wait: 5)
      expect(page).to have_css('#operations-foos-getApiFoos.is-open', wait: 5)
    end

    it 'navigates to a different operation deep link after already viewing one' do
      visit '/swagger#/foos/getApiFoos'
      expect(page).to have_css('.swagger-ui', wait: 5)
      expect(page).to have_css('#operations-foos-getApiFoos.is-open', wait: 5)

      visit '/swagger#/foos/getApiFoosId'
      expect(page).to have_css('.swagger-ui', wait: 5)
      expect(page).to have_css('#operations-foos-getApiFoosId.is-open', wait: 5)
    end

    it 'expands the target operation when the hash fragment changes via JS in the same page' do
      visit_swagger

      page.execute_script("window.location.hash = '#/foos/getApiFoos'")
      expect(page).to have_css('#operations-foos-getApiFoos.is-open', wait: 5)
    end
  end

  context 'swaggerUi' do
    before do
      visit_swagger
    end

    it 'loads foos resource' do
      expect(page).to have_text('foos')
    end

    it 'loads Swagger UI' do
      expect(page.evaluate_script('typeof window.ui')).to eq 'object'
    end

    it 'loads the configured swagger document URL' do
      expect(swagger_configs.fetch('url')).to eq 'http://localhost:3000/api/swagger_doc'
    end

    it 'shows the Swagger 2 document badge' do
      expect(page).to have_css('.swagger-ui .info .version', text: 'OAS 2.0')
    end

    it 'serves a Swagger 2 document' do
      document = swagger_document

      expect(document['swagger']).to eq('2.0')
      expect(document).not_to have_key('openapi')
      expect(document.fetch('paths')).to include('/api/headers', '/api/echo', '/api/submit', '/api/create')
    end

    it 'documents the echo endpoint as form data with form encoding' do
      document = swagger_document
      operation = document.fetch('paths').fetch('/api/echo').fetch('post')

      expect(operation.fetch('consumes')).to eq(['application/x-www-form-urlencoded'])
      expect(operation.fetch('parameters')).to include(
        a_hash_including('in' => 'formData', 'name' => 'name', 'type' => 'string'),
        a_hash_including('in' => 'formData', 'name' => 'enabled', 'type' => 'boolean')
      )
    end

    it 'documents the submit endpoint with JSON consumes' do
      operation = swagger_document.dig('paths', '/api/submit', 'post')
      expect(operation.fetch('consumes')).to eq(['application/json'])

      if Gem::Version.new(GrapeSwagger::VERSION) >= Gem::Version.new('2.0')
        expect(operation.fetch('parameters').map { |p| p['in'] }.uniq).to eq(['body'])
      else
        expect(operation.fetch('parameters').map { |p| p['in'] }.uniq).to eq(['formData'])
      end
    end

    it 'documents the create endpoint with multiple consumes values' do
      operation = swagger_document.dig('paths', '/api/create', 'post')

      expect(operation.fetch('consumes')).to eq(%w[application/json application/x-www-form-urlencoded])
      expect(operation.fetch('parameters')).to include(
        a_hash_including('in' => 'formData', 'name' => 'name'),
        a_hash_including('in' => 'formData', 'name' => 'enabled')
      )
    end

    it 'contrasts consumes and parameter styles between endpoints' do
      document = swagger_document
      echo_op = document.dig('paths', '/api/echo', 'post')
      submit_op = document.dig('paths', '/api/submit', 'post')

      expect(echo_op.fetch('consumes')).to eq(['application/x-www-form-urlencoded'])
      expect(submit_op.fetch('consumes')).to eq(['application/json'])
      expect(echo_op.fetch('parameters').map { |p| p['in'] }.uniq).to eq(['formData'])
      expected_in = Gem::Version.new(GrapeSwagger::VERSION) >= Gem::Version.new('2.0') ? 'body' : 'formData'
      expect(submit_op.fetch('parameters').map { |p| p['in'] }.uniq).to eq([expected_in])
    end

    it 'executes a GET request through Swagger UI and applies custom headers' do
      GrapeSwaggerRails.options.headers['X-Test-Header'] = 'Smoke'

      visit_swagger
      open_operation('operations-tag-headers', 'operations-headers-getApiHeaders')
      execute_operation('operations-headers-getApiHeaders')

      expect(page).to have_text(/"x-test-header": "Smoke"/i)
      expect(page).to have_text("curl -X 'GET'")
    end

    context 'POST request via Swagger UI' do
      before do
        GrapeSwaggerRails.options.headers['X-Test-Header'] = 'Smoke'
        visit_swagger
        open_operation('operations-tag-echo', 'operations-echo-postApiEcho')
        fill_echo_form
      end

      it 'submits form-encoded body' do
        expect(page).to have_text('"body": "name=Widget&enabled=true"')
        expect(page).to have_text('"content_type": "application/x-www-form-urlencoded"')
        expect(page).to have_text('"name": "Widget"')
        expect(page).to have_text('"enabled": true')
      end

      it 'forwards custom headers' do
        expect(page).to have_text('"X-Test-Header": "Smoke"')
      end
    end
  end

  describe '#options' do
    before do
      @options = GrapeSwaggerRails.options.dup
    end

    after do
      GrapeSwaggerRails.options = @options
    end

    it 'evaluates config options correctly' do
      visit_swagger
      page_options = swagger_options_data.symbolize_keys
      page_options[:display] = page_options[:display].symbolize_keys if page_options[:display].is_a?(Hash)
      expect(page_options).to eq(@options.marshal_dump)
    end

    describe '#headers' do
      before do
        GrapeSwaggerRails.options.headers['X-Test-Header'] = 'Test Value'
        GrapeSwaggerRails.options.headers['X-Another-Header'] = 'Another Value'
        visit_swagger
      end

      it 'adds headers' do
        request = intercepted_request('http://localhost:3000/api/headers')

        expect(request.fetch('headers')).to include(
          'X-Test-Header' => 'Test Value',
          'X-Another-Header' => 'Another Value'
        )
      end

      it 'supports multiple headers' do
        request = intercepted_request('http://localhost:3000/api/headers')

        expect(request.fetch('headers').keys).to include('X-Test-Header', 'X-Another-Header')
      end

      it 'adds headers when the request uses a Headers object' do
        request = intercepted_request_with_headers_object('http://localhost:3000/api/headers')

        expect(request.fetch('headers')).to include(
          'testHeader' => 'Test Value',
          'anotherHeader' => 'Another Value'
        )
      end

      it 'initializes request headers when they are missing' do
        request = intercepted_request_without_headers('http://localhost:3000/api/headers')

        expect(request.fetch('headers')).to include(
          'X-Test-Header' => 'Test Value',
          'X-Another-Header' => 'Another Value'
        )
      end
    end

    describe '#urls' do
      before do
        GrapeSwaggerRails.options.urls = [
          { name: 'v1', url: '/api/swagger_doc' },
          { name: 'v2', url: '/api/v2/swagger_doc', default: true }
        ]
        GrapeSwaggerRails.options.url = '/api/swagger_doc'
        visit_swagger
      end

      it 'passes multiple spec URLs to Swagger UI' do
        configs = swagger_configs

        expect(configs.fetch('urls')).to eq(
          [
            { 'name' => 'v1', 'url' => 'http://localhost:3000/api/swagger_doc' },
            { 'name' => 'v2', 'url' => 'http://localhost:3000/api/v2/swagger_doc' }
          ]
        )
      end

      it 'shows a selector with v2 selected by default' do
        expect(page).to have_select('spec-selector', selected: 'v2', options: %w[v1 v2])
      end

      it 'auto-loads the default spec on first paint without manual selection' do
        # v2 exposes the `status` tag; it must render without the user touching the dropdown.
        expect(page).to have_css('.opblock-tag', text: 'status', wait: 10)
        expect(page).to have_no_css('.errors-wrapper')
        expect(page).to have_no_text('No API definition provided')
      end

      it 'switches specs via the dropdown without errors' do
        expect(page).to have_select('spec-selector', selected: 'v2')

        select 'v1', from: 'spec-selector'

        # v1 exposes foos namespace; wait for it to appear in the rendered spec
        expect(page).to have_css('.opblock-tag', text: 'foos', wait: 10)
        expect(page).to have_no_css('.errors-wrapper')
      end

      context 'when no url has default: true' do
        before do
          GrapeSwaggerRails.options.urls = [
            { name: 'v1', url: '/api/swagger_doc' },
            { name: 'v2', url: '/api/v2/swagger_doc' }
          ]
          GrapeSwaggerRails.options.url = '/api/swagger_doc'
          visit_swagger
        end

        it 'falls back to the url option to determine the default selection' do
          expect(page).to have_select('spec-selector', selected: 'v1', options: %w[v1 v2])
        end
      end
    end

    describe '#swagger_ui_config' do
      before do
        GrapeSwaggerRails.options.swagger_ui_config = {
          'defaultModelsExpandDepth' => -1,
          'displayRequestDuration' => true
        }
        visit_swagger
      end

      it 'passes native Swagger UI config through to the bundle' do
        configs = swagger_configs

        expect(configs.fetch('defaultModelsExpandDepth')).to eq(-1)
        expect(configs.fetch('displayRequestDuration')).to be(true)
      end
    end

    describe '#api_key_default_value' do
      before do
        GrapeSwaggerRails.options.api_auth = 'bearer'
        GrapeSwaggerRails.options.api_key_name = 'Authorization'
        GrapeSwaggerRails.options.api_key_type = 'header'
        GrapeSwaggerRails.options.api_key_default_value = 'token'
        visit_swagger
      end

      it 'adds an Authorization header' do
        request = intercepted_request('http://localhost:3000/api/headers')

        expect(request.fetch('headers')).to include('Authorization' => 'Bearer token')
      end
    end

    describe '#api_key_placeholder' do
      before do
        GrapeSwaggerRails.options.api_key_placeholder = 'authorization_code'
        visit_swagger
      end

      it 'adds a custom placeholder' do
        expect(find_by_id('input_apiKey')['placeholder']).to eq 'authorization_code'
        expect(page).to have_no_css('.swagger-auth .swagger-label')
      end
    end

    describe '#api_auth:basic' do
      before do
        GrapeSwaggerRails.options.api_auth = 'basic'
        GrapeSwaggerRails.options.api_key_name = 'Authorization'
        GrapeSwaggerRails.options.api_key_type = 'header'
        visit_swagger
      end

      it 'adds an Authorization header' do
        fill_api_key('username:password')

        request = intercepted_request('http://localhost:3000/api/headers')

        expect(request.fetch('headers')).to include(
          'Authorization' => "Basic #{Base64.encode64('username:password').strip}"
        )
      end
    end

    describe '#api_auth:bearer' do
      before do
        GrapeSwaggerRails.options.api_auth = 'bearer'
        GrapeSwaggerRails.options.api_key_name = 'Authorization'
        GrapeSwaggerRails.options.api_key_type = 'header'
        visit_swagger
      end

      it 'adds an Authorization header' do
        fill_api_key('token')

        request = intercepted_request('http://localhost:3000/api/headers')

        expect(request.fetch('headers')).to include('Authorization' => 'Bearer token')
      end
    end

    describe '#api_auth:token and #api_key_type:header' do
      before do
        GrapeSwaggerRails.options.api_auth = 'token'
        GrapeSwaggerRails.options.api_key_name = 'Authorization'
        GrapeSwaggerRails.options.api_key_type = 'header'
        visit_swagger
      end

      it 'adds an Authorization header' do
        fill_api_key('token')

        request = intercepted_request('http://localhost:3000/api/headers')

        expect(request.fetch('headers')).to include('Authorization' => 'Token token="token"')
      end

      it 'adds an Authorization header when the request uses a Headers object' do
        fill_api_key('token')

        request = intercepted_request_with_headers_object('http://localhost:3000/api/headers')

        expect(request.fetch('headers')).to include('authorization' => 'Token token="token"')
      end
    end

    describe '#api_auth:token' do
      before do
        GrapeSwaggerRails.options.api_key_name = 'api_token'
        GrapeSwaggerRails.options.api_key_type = 'query'
        visit_swagger
      end

      it 'adds an api_token query parameter' do
        fill_api_key('dummy')

        request = intercepted_request('http://localhost:3000/api/params')

        expect(request.fetch('url')).to eq 'http://localhost:3000/api/params?api_token=dummy'
      end
    end

    describe '#before_filter' do
      before do
        allow(GrapeSwaggerRails.deprecator).to receive(:warn)
      end

      it 'throws deprecation warning' do
        GrapeSwaggerRails.options.before_filter { true }

        expect(GrapeSwaggerRails.deprecator).to have_received(:warn).with(
          'This option is deprecated and going to be removed in 1.0.0. ' \
          'Please use `before_action` instead'
        )
      end
    end

    describe '#before_action' do
      before do
        GrapeSwaggerRails.options.before_action do |_request|
          flash[:error] = 'Unauthorized Access'
          redirect_to '/'
          false
        end
        visit '/swagger'
      end

      it 'denies access' do
        expect(page).to have_current_path '/', ignore_query: true
        expect(page).to have_text 'Unauthorized Access'
      end
    end

    describe '#app_name' do
      context 'set' do
        before do
          GrapeSwaggerRails.options.app_name = 'Test App'
          visit_swagger
        end

        it 'sets page title' do
          expect(page.title).to eq 'Test App'
        end
      end

      context 'not set' do
        before do
          visit_swagger
        end

        it 'defaults page title' do
          expect(page.title).to eq 'Swagger'
        end
      end
    end

    describe '#theme' do
      context 'not set' do
        before do
          visit_swagger
        end

        it 'defaults to light mode' do
          expect(theme_state).to include(
            'theme' => 'light',
            'buttonLabel' => 'Dark Mode',
            'pressed' => 'false'
          )
        end
      end

      context 'set dark' do
        before do
          GrapeSwaggerRails.options.theme = 'dark'
          visit_swagger
        end

        it 'uses dark mode on load' do
          expect(theme_state).to include(
            'theme' => 'dark',
            'buttonLabel' => 'Light Mode',
            'pressed' => 'true'
          )
        end

        it 'switches back to light mode' do
          click_button 'Light Mode'

          expect(theme_state).to include(
            'theme' => 'light',
            'buttonLabel' => 'Dark Mode',
            'pressed' => 'false'
          )
        end
      end
    end

    describe '#doc_expansion' do
      context 'set list' do
        before do
          GrapeSwaggerRails.options.doc_expansion = 'list'
          visit_swagger
        end

        it 'sets SwaggerUI docExpansion with list' do
          expect(swagger_configs.fetch('docExpansion')).to eq 'list'
        end
      end

      context 'set full' do
        before do
          GrapeSwaggerRails.options.doc_expansion = 'full'
          visit_swagger
        end

        it 'sets SwaggerUI docExpansion with full' do
          expect(swagger_configs.fetch('docExpansion')).to eq 'full'
        end
      end

      context 'not set' do
        before do
          visit_swagger
        end

        it 'defaults SwaggerUI docExpansion' do
          expect(swagger_configs.fetch('docExpansion')).to eq 'none'
        end
      end
    end

    describe '#supported_submit_methods' do
      context 'set all operations' do
        before do
          GrapeSwaggerRails.options.supported_submit_methods = %w[get post put delete patch]
          visit_swagger
        end

        it 'sets SwaggerUI supportedSubmitMethods with all operations' do
          expect(swagger_configs.fetch('supportedSubmitMethods')).to eq %w[get post put delete patch]
        end
      end

      context 'set some operations' do
        before do
          GrapeSwaggerRails.options.supported_submit_methods = ['post']
          visit_swagger
        end

        it 'sets SwaggerUI supportedSubmitMethods with some operations' do
          expect(swagger_configs.fetch('supportedSubmitMethods')).to eq ['post']
        end
      end

      context 'set nil' do
        before do
          GrapeSwaggerRails.options.supported_submit_methods = nil
          visit_swagger
        end

        it 'clears SwaggerUI supportedSubmitMethods' do
          expect(swagger_configs.fetch('supportedSubmitMethods')).to eq []
        end
      end

      context 'not set' do
        before do
          visit_swagger
        end

        it 'defaults SwaggerUI supportedSubmitMethods' do
          expect(swagger_configs.fetch('supportedSubmitMethods')).to eq %w[get post put delete patch]
        end
      end
    end

    describe '#validator_url' do
      context 'set null' do
        before do
          GrapeSwaggerRails.options.validator_url = nil
          visit_swagger
        end

        it 'sets SwaggerUI validatorUrl to null' do
          expect(swagger_configs.fetch('validatorUrl')).to be_nil
          expect(swagger_configs.fetch('validatorType')).to eq 'object'
        end
      end

      context 'set a url' do
        before do
          GrapeSwaggerRails.options.validator_url = 'http://www.example.com/'
          visit_swagger
        end

        it 'sets SwaggerUI validatorUrl to expected url' do
          expect(swagger_configs.fetch('validatorUrl')).to eq 'http://www.example.com/'
        end
      end

      context 'not set' do
        before do
          visit_swagger
        end

        it 'defaults SwaggerUI validatorUrl' do
          expect(swagger_configs.fetch('validatorUrl')).to eq 'undefined'
          expect(swagger_configs.fetch('validatorType')).to eq 'string'
        end
      end
    end

    describe 'Authorize button (Swagger UI security schemes)' do
      include_context 'with isolated options'

      it 'serves the api_key security definition in the swagger document' do
        document = swagger_document

        expect(document.fetch('securityDefinitions')).to eq(
          'api_key' => { 'type' => 'apiKey', 'name' => 'Authorization',
                         'in' => 'header' }
        )
      end

      it 'records the per-endpoint security requirement on the secured operation' do
        operation = swagger_document.dig('paths', '/api/headers', 'get')

        expect(operation.fetch('security')).to eq([{ 'api_key' => [] }])
      end

      it 'renders the global Authorize button in the scheme container' do
        visit_swagger

        expect(page).to have_css('.swagger-ui .scheme-container .auth-wrapper .btn.authorize', wait: 5)
      end

      it 'renders the per-endpoint padlock on the secured operation' do
        GrapeSwaggerRails.options.doc_expansion = 'list'
        visit_swagger

        expect(page).to have_css(
          '#operations-headers-getApiHeaders .opblock-summary .authorization__btn', wait: 5
        )
      end

      it 'does not render the padlock on operations without a security requirement' do
        GrapeSwaggerRails.options.doc_expansion = 'list'
        visit_swagger

        expect(page).to have_css('#operations-foos-getApiFoos .opblock-summary', wait: 5)
        expect(page).to have_no_css('#operations-foos-getApiFoos .opblock-summary .authorization__btn')
      end
    end
  end
end
