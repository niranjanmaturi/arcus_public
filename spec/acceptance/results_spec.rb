require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Results" do
  get 'devices/:device_id/templates/:template_id/results.:format' do
    let(:service_account) { create(:service_account) }
    let(:steps) { [ build(:step, sort_order: 1, apply_template: true, request_option: build(:request_option)) ] }
    let(:device_type) { create(:device_type, steps: steps) }
    let(:device) { create(:device, device_type: device_type) }
    let(:template_body) { '' }
    let(:request_option) { create(:request_option, url: url, http_method: http_methodz, body: template_body, basic_auth: nil) }
    let(:template) { create(:template, transformation: transformation, device_type: device_type, request_option: request_option) }
    let(:device_id) { device.id }
    let(:template_id) { template.id }
    let(:http_methodz) { 'get' }
    let(:format) { 'c3' }
    let(:authorization) { "Basic #{::Base64.strict_encode64("#{service_account.username}:#{service_account.password}")}" }
    let(:url) { Faker::Lorem.words(5).join('/') }

    let(:expected_response) do
      10.times.map do |i|
        {
          name: "#{Faker::Lorem.word}#{i}",
          displayName: "#{Faker::Lorem.sentence}#{i}"
        }
      end
    end

    let(:device_response) do

      {
        barks: expected_response.map do |hsh|
          {
            stuff: Faker::Lorem.word,
            name: hsh[:displayName],
            thing: {
              dude: hsh[:name]
            }
          }
        end
      }
    end

    let(:transformation) do
      <<-TEXT
        <?xml version="1.0" encoding="ISO-8859-1"?>
        <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
          <xsl:template match="/">
            <root>
              <xsl:for-each select="root/barks/bark">
                <results>
                  <data><xsl:value-of select="thing/dude"/></data>
                  <label><xsl:value-of select="name"/></label>
                </results>
              </xsl:for-each>
            </root>
          </xsl:template>
        </xsl:stylesheet>
      TEXT
    end

    before do
      header 'Authorization', authorization
    end

    context 'authorization happy paths' do

      context 'multistep with ucs' do
        let(:http_methodz) { 'post' }
        let(:token) { Faker::Internet.password }
        let(:auth_reponse) do
          <<-BLAH
            <aaaLogin outCookie="#{token}"> </aaaLogin>
          BLAH
        end
        let(:expected_auth_body) do
          "<aaaLogin inName=\"#{device.username}\" inPassword=\"#{device.password}\" />"
        end

        let(:expected_query_body) do
          <<~TEXT
          <configResolveClasses
              cookie="#{token}"
              inHierarchical="false"
          >
          <inIds>
          <Id value="fabricVlan" />
          </inIds>
          </configResolveClasses>
          TEXT
        end

        let(:expected_response) do
          [
            { 'name' => 'one', 'displayName' => 'a' },
            { 'name' => 'two', 'displayName' => 'b' },
            { 'name' => 'three', 'displayName' => 'c' },
            { 'name' => 'four', 'displayName' => 'd' },
          ]
        end

        let(:device_response) do
          <<~TEXT
            <configResolveClasses>
                <outConfigs>
                  <fabricVlan dn="one" name="a" />
                  <fabricVlan dn="two" name="b" />
                  <fabricVlan dn="three" name="c" />
                  <fabricVlan dn="four" name="d" />
                </outConfigs>
            </configResolveClasses>
          TEXT
        end


        let(:template_body) do
          <<~TEXT
          <configResolveClasses
              cookie="${xml(token)}"
              inHierarchical="false"
          >
          <inIds>
          <Id value="fabricVlan" />
          </inIds>
          </configResolveClasses>
          TEXT
        end

        let(:transformation) do
          <<~TEXT
            <?xml version="1.0" encoding="ISO-8859-1"?>
            <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
              <xsl:template match="/">
                <root>
                  <xsl:for-each select="configResolveClasses/outConfigs/fabricVlan">
                    <results>
                      <data><xsl:value-of select="@dn"/></data>
                      <label><xsl:value-of select="@name"/></label>
                    </results>
                  </xsl:for-each>
                </root>
              </xsl:template>
            </xsl:stylesheet>
          TEXT
        end


        let(:steps) do
          [
            build(:step,
              name: 'Auth',
              sort_order: 1,
              apply_template: false,
              request_option: build(:request_option,
                http_method: 'post',
                body: '<aaaLogin inName="${xml(username)}" inPassword="${xml(password)}" />',
                basic_auth: false
              ),
              step_variables: [
                build(:step_variable,
                  name: 'token',
                  sort_order: 1,
                  source_type: 'xpath',
                  value: '/aaaLogin/@outCookie'
                )
              ]
            ),
            build(:step,
              name: 'Query',
              sort_order: 2,
              apply_template: true,
              request_option: build(:request_option,
                http_method: 'get',
                url: '',
                body: '',
                basic_auth: false,
              )
            ),
          ]
        end

        before do
          stub_request(:post, device.base_url + steps[0].request_option.url).with(body: expected_auth_body).and_return({
            status: 200,
            headers: {
              content_type: 'application/soap+xml'
            },
            body: auth_reponse
          })

          stub_request(:post, device.base_url + template.request_option.url).with(body: expected_query_body).and_return({
            status: 200,
            headers: {
              content_type: 'application/soap+xml'
            },
            body: device_response
          })
        end

        it 'returns the correct data' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq(expected_response.to_json)
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end

      context 'multi-step with token auth (ViPR)' do
        let(:token_variable) { Faker::Lorem.words(3).join }
        let(:token_header) { Faker::Lorem.words(3).join }
        let(:token_value) { Faker::Lorem.words(3).join }
        let(:basic_auth_header) do
          { 'Authorization' => "Basic #{::Base64.strict_encode64("#{device.username}:#{device.password}")}" }
        end
        let(:steps) do
          [
            build(:step,
              name: 'Auth',
              sort_order: 1,
              apply_template: false,
              request_option: build(:request_option,
                http_method: 'get',
                body: '',
                basic_auth: true
              ),
              step_variables: [
                build(:step_variable,
                  name: token_variable,
                  sort_order: 1,
                  source_type: 'header',
                  value: token_header
                )
              ]
            ),
            build(:step,
              name: 'Query',
              sort_order: 2,
              apply_template: true,
              request_option: build(:request_option,
                http_method: 'get',
                url: '',
                body: '',
                basic_auth: false,
                headers: [
                  build(:header,
                    name: token_header,
                    value: "${#{token_variable}}"
                  )
                ]
              )
            ),
          ]
        end

        before do
          stub_request(:get, device.base_url + steps[0].request_option.url).with(headers: basic_auth_header).and_return({
            status: 200,
            headers: {
              content_type: 'application/json',
              token_header => token_value
            }
          })
          stub_request(:get, device.base_url + template.request_option.url).with(headers: { token_header => token_value }).and_return({
            status: 200,
            body: device_response.to_json,
            headers: { content_type: 'application/json' }
          })
        end

        example 'it returns the correct data' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq(expected_response.to_json)
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end

      context 'multi-step (invented) to test jsonpath' do
        let(:json_value) { Faker::Lorem.words(3).join }
        let(:json_param_name) { Faker::Lorem.words(3).join }
        let(:json_header_name) { Faker::Lorem.words(3).join }
        let(:json_path) { json_pieces.join('.') }
        let(:json_pieces) { Faker::Lorem.words(3) }
        let(:auth_body) do
          {
            json_pieces[0] => {
              json_pieces[1] => {
                json_pieces[2] => json_value
              }
            }
          }
        end
        let(:steps) do
          [
            build(:step,
              name: 'Auth',
              sort_order: 1,
              apply_template: false,
              request_option: build(:request_option,
                http_method: 'get',
                body: '',
                basic_auth: false
              ),
              step_variables: [
                build(:step_variable,
                  name: json_param_name,
                  sort_order: 1,
                  source_type: 'jsonpath',
                  value: json_path
                )
              ]
            ),
            build(:step,
              name: 'Query',
              sort_order: 2,
              apply_template: true,
              request_option: build(:request_option,
                http_method: 'get',
                url: '',
                body: '',
                basic_auth: false,
                headers: [
                  build(:header,
                    name: json_header_name,
                    value: "${#{json_param_name}}"
                  )
                ]
              )
            ),
          ]
        end

        let(:query_stub) do
          stub_request(:get, device.base_url + template.request_option.url).with(headers: { json_header_name => json_value }).and_return({
            status: 200,
            body: device_response.to_json,
            headers: { content_type: 'application/json' }
          })
        end

        before do
          stub_request(:get, device.base_url + steps[0].request_option.url).and_return({
            status: 200,
            body: auth_body.to_json,
            headers: {
              content_type: 'application/json'
            }
          })

          query_stub
        end

        example 'it returns the correct data' do
          do_request

          expect(query_stub).to have_been_requested

          expect(status).to eq(200)
          expect(response_body).to eq(expected_response.to_json)
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end

      context 'multistep with cookie auth (ACI)' do
        let(:cookie) { Faker::Lorem.paragraph }
        let(:steps) do
          [
            build(:step,
              apply_template: false,
              sort_order: 1,
              request_option: build(:request_option,
                http_method: 'post',
                body: '{ "aaaUser": { "attributes": { "name": "${json(username)}", "pwd": "${json(password)}" } } }',
                basic_auth: false,
              ),
              step_variables: [
                build(:step_variable,
                  name: 'cookie',
                  source_type: 'header',
                  value: 'Set-Cookie'
                )
              ]
            ),
            build(:step,
              apply_template: true,
              sort_order: 2,
              request_option: build(:request_option,
                http_method: 'get',
                body: '',
                basic_auth: false,
                headers: [
                  build(:header,
                    name: 'Cookie',
                    value: '${cookie}'
                  )
                ]
              )
            ),
          ]
        end

        before do
          expected_body = '{ "aaaUser": { "attributes": { "name": "' + device.username + '", "pwd": "' + device.password + '" } } }'
          stub_request(:post, device.base_url + steps[0].request_option.url).with(body: expected_body).and_return({ status: 200, headers: { content_type: 'application/json', 'Set-Cookie': cookie } })
          stub_request(:get, device.base_url + template.request_option.url).with(headers: { Cookie: cookie }).and_return({ status: 200, body: device_response.to_json, headers: { content_type: 'application/json' } })
        end

        example 'it returns the correct data' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq(expected_response.to_json)
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end

      context 'multi-step with basic auth' do
        let(:basic_auth_header) do
          { 'Authorization' => "Basic #{::Base64.strict_encode64("#{device.username}:#{device.password}")}" }
        end
        let(:steps) { [ build(:step, sort_order: 1, apply_template: true, request_option: build(:request_option, basic_auth: true)) ] }

        before do
          stub_request(:get, device.base_url + template.request_option.url).with(headers: basic_auth_header).and_return({
            status: 200,
            body: device_response.to_json,
            headers: { content_type: 'application/json' }
          })
        end

        example 'it returns the correct data' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq(expected_response.to_json)
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end

      context 'with parameter' do
        parameter :banana
        let(:banana) { 'weber' }
        let(:url) { 'goofy/${banana}.json' }

        before do
          stub_request(:get, device.base_url + 'goofy/weber.json').and_return({
            status: 200,
            body: device_response.to_json,
            headers: { content_type: 'application/json' }
          })
        end

        example 'it returns the correct data' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq(expected_response.to_json)
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end
    end

    context 'with missing device' do
      let(:device_id) { rand(50_000) + 50_000 }
      example 'it returns the proper 404 error code' do
        do_request

        expect(status).to eq(404)
      end
    end

    context 'with missing template' do
      let(:template_id) { rand(50_000) + 50_000 }
      example 'it returns the proper 404 error code' do
        do_request

        expect(status).to eq(404)
      end
    end

    context 'with non matching device types on device and template' do
      let(:template) { create :template, device_type: create(:device_type) }

      example 'it returns a 200 with no name and error in displayName' do
        do_request

        expect(status).to eq(200)
        expect(response_body).to eq([{ name: '', displayName: 'Device type does not match template type.' }].to_json)
        expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
      end
    end

    context 'no authentication' do
      let(:authorization) { "" }

      example 'it returns the proper 401 error code' do
        do_request

        expect(status).to eq(401)
      end
    end

    context 'bad authentication' do
      let(:authorization) { "Basic #{::Base64.strict_encode64("username:password")}" }

      example 'it returns the proper 401 error code' do
        do_request

        expect(status).to eq(401)
      end
    end

    context 'missing parameter' do
      let(:url) { 'goofy/${banana}.json' }

      example 'it returns a 200 with no name and error in displayName' do
        do_request

        expect(status).to eq(200)
        expect(response_body).to eq([{ name: '', displayName: 'missing parameter banana' }].to_json)
        expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
      end
    end

    context 'host returned an error code' do
      let(:error_code) { Rack::Utils::SYMBOL_TO_STATUS_CODE.values.select{|v| v >= 400 }.sample }
      let(:error_msg) { "Error: Received HTTP code #{error_code} when querying #{hostname} via #{scheme}" }
      let(:device_url) { URI.parse(device.base_url) }
      let(:scheme) { device_url.scheme}
      let(:hostname) { device_url.hostname }

      before do
        stub_request(:get, device.base_url + template.request_option.url).and_return(status: error_code)
      end

      example 'it propogates the error code to the user' do
        do_request

        expect(status).to eq(200)
        expect(response_body).to eq([{ name: '', displayName: error_msg }].to_json)
        expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
      end
    end

    context 'host not found' do
      let(:uri) { URI.parse(device.base_url) }

      context 'timing out' do
        before do
          stub_request(:get, device.base_url + template.request_option.url).to_timeout
        end

        example 'it returns a 200 with no name and error in displayName' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq([{ name: '', displayName: "Error: Connection timeout when querying #{uri.hostname} via #{uri.scheme}" }].to_json)
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end

      context 'bad hostname' do
        let(:uri) { URI.parse(device.base_url) }

        before do
          stub_request(:get, device.base_url + template.request_option.url).to_raise(SocketError)
        end

        example 'it returns a 200 with no name and error in displayName' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq([{ name: '', displayName: "Error: Host not found when querying #{uri.hostname} via #{uri.scheme}" }].to_json)
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end

      context 'connection refused' do
        let(:uri) { URI.parse(device.base_url) }

        before do
          stub_request(:get, device.base_url + template.request_option.url).to_raise(Errno::ECONNREFUSED)
        end

        example 'it returns a 200 with no name and error in displayName' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq([{ name: '', displayName: "Error: Connection refused when querying #{uri.hostname} via #{uri.scheme}" }].to_json)
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end

      context 'ssl validation fails' do
        let(:uri) { URI.parse(device.base_url) }

        before do
          stub_request(:get, device.base_url + template.request_option.url).to_raise(OpenSSL::SSL::SSLError)
        end

        example 'it returns a 200 with no name and error in displayName' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq([{ name: '', displayName: "Error: SSL validation failed when querying #{uri.hostname} via #{uri.scheme}" }].to_json)
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end

      context 'read timeout' do
        let(:uri) { URI.parse(device.base_url) }

        before do
          stub_request(:get, device.base_url + template.request_option.url).to_raise(Net::ReadTimeout)
        end

        example 'it returns a 200 with no name and error in displayName' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq([{ name: '', displayName: "Error: Connection timeout when querying #{uri.hostname} via #{uri.scheme}" }].to_json)
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end
    end

    context 'when transformation throws an error' do
      let(:transformation) do
        <<-TEXT
        <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
          <xsl:template match="/">
            <xsl:message terminate="yes">ERROR: Missing attribute XYZ</xsl:message>
          </xsl:template>
        </xsl:stylesheet>
        TEXT
      end

      before do
        stub_request(:get, device.base_url + template.request_option.url).and_return({
          status: 200,
          body: device_response.to_json,
          headers: { content_type: 'application/json' }
        })
      end

      example 'it returns a 200 with no name and error in displayName' do
        do_request

        expect(status).to eq(200)
        expect(response_body).to eq([{ name: '', displayName: 'Error applying transform: ERROR: Missing attribute XYZ' }].to_json)
        expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
      end
    end

    context 'when transformation returns a bad result' do
      let(:transformation) do
        <<-TEXT
        <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
          <xsl:template match="/">
            <root>
              <results>
                <data>something</data>
                <label>otherthing</label>
                this is not really proper, right?
              </results>
            </root>
          </xsl:template>
        </xsl:stylesheet>
        TEXT
      end

      before do
        stub_request(:get, device.base_url + template.request_option.url).and_return({
          status: 200,
          body: device_response.to_json,
          headers: { content_type: 'application/json' }
        })
      end

      example 'it returns a 200 with no name and error in displayName' do
        do_request

        expect(status).to eq(200)
        expect(response_body).to eq([{ name: '', displayName: 'Error parsing transformation result. Each <results> element requires a child <data> element and a child <label> element' }].to_json)
        expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
      end
    end

    context 'when transformation is missing a required field' do
      let(:steps) do
        [
          build(:step,
            name: 'Query',
            sort_order: 1,
            apply_template: true,
            request_option: build(:request_option,
              http_method: 'get',
              url: '',
              body: '',
              basic_auth: false,
              headers: []
            )
          )
        ]
      end
      before do
        stub_request(:get, device.base_url + template.request_option.url).and_return({
          status: 200,
          body: device_response.to_json,
          headers: { content_type: 'application/json' }
        })
      end

      context 'when the transform has nothing in it' do
        let(:transformation) do
          <<-TEXT
          <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
            <xsl:template match="/">
            </xsl:template>
          </xsl:stylesheet>
          TEXT
        end

        example 'it returns a 200 with the appropriate error message' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq( [{name: '', displayName: 'Error parsing transformation result. Missing root element <root>'}].to_json )
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end

      context 'when the transform is missing the root element, but has other elements' do
        let(:transformation) do
          <<-TEXT
            <?xml version="1.0" encoding="ISO-8859-1"?>
            <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
              <xsl:template match="/">
                <xsl:for-each select="root/barks/bark">
                  <results>
                    <data><xsl:value-of select="thing/dude"/></data>
                    <label><xsl:value-of select="name"/></label>
                  </results>
                </xsl:for-each>
              </xsl:template>
            </xsl:stylesheet>
          TEXT
        end
        example 'it returns a 200 with the appropriate error message' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq( [{name: '', displayName: 'Error parsing transformation result. Missing root element <root>'}].to_json )
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end

      context 'when the transform is missing the data element' do
        let(:transformation) do
          <<-TEXT
            <?xml version="1.0" encoding="ISO-8859-1"?>
            <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
              <xsl:template match="/">
                <root>
                  <xsl:for-each select="root/barks/bark">
                    <results>
                      <label><xsl:value-of select="name"/></label>
                    </results>
                  </xsl:for-each>
                </root>
              </xsl:template>
            </xsl:stylesheet>
          TEXT
        end
        example 'it returns a 200 with the appropriate error message' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq( [{name: '', displayName: 'Error parsing transformation result. Each <results> element requires a child <data> element'}].to_json )
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end
      context 'when the transform is missing the label element' do
        let(:transformation) do
          <<-TEXT
            <?xml version="1.0" encoding="ISO-8859-1"?>
            <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
              <xsl:template match="/">
                <root>
                  <xsl:for-each select="root/barks/bark">
                    <results>
                      <data><xsl:value-of select="thing/dude"/></data>
                    </results>
                  </xsl:for-each>
                </root>
              </xsl:template>
            </xsl:stylesheet>
          TEXT
        end
        example 'it returns a 200 with the appropriate error message' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq( [{name: '', displayName: 'Error parsing transformation result. Each <results> element requires a child <label> element'}].to_json )
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end
      context 'when the transform is missing only one data element' do
        let(:transformation) do
          <<-TEXT
            <?xml version="1.0" encoding="ISO-8859-1"?>
            <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
              <xsl:template match="/">
                <root>
                  <xsl:for-each select="root/barks/bark">
                    <results>
                      <xsl:if test="position()!=1">
                        <data><xsl:value-of select="thing/dude"/></data>
                      </xsl:if>
                      <label><xsl:value-of select="name"/></label>
                    </results>
                  </xsl:for-each>
                </root>
              </xsl:template>
            </xsl:stylesheet>
          TEXT
        end
        example 'it returns a 200 with the appropriate error message' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq( [{name: '', displayName: 'Error parsing transformation result. Each <results> element requires a child <data> element'}].to_json )
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end
      context 'when the transform is missing only one label element' do
        let(:transformation) do
          <<-TEXT
            <?xml version="1.0" encoding="ISO-8859-1"?>
            <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
              <xsl:template match="/">
                <root>
                  <xsl:for-each select="root/barks/bark">
                    <results>
                      <data><xsl:value-of select="thing/dude"/></data>
                      <xsl:if test="position()!=1">
                        <label><xsl:value-of select="name"/></label>
                      </xsl:if>
                    </results>
                  </xsl:for-each>
                </root>
              </xsl:template>
            </xsl:stylesheet>
          TEXT
        end
        example 'it returns a 200 with the appropriate error message' do
          do_request

          expect(status).to eq(200)
          expect(response_body).to eq( [{name: '', displayName: 'Error parsing transformation result. Each <results> element requires a child <label> element'}].to_json )
          expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
        end
      end
    end

    context 'when transformation returns no data' do
      let(:transformation) do
        <<-TEXT
        <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
          <xsl:template match="/">
            <root>
            </root>
          </xsl:template>
        </xsl:stylesheet>
        TEXT
      end

      before do
        stub_request(:get, device.base_url + template.request_option.url).and_return({
          status: 200,
          body: device_response.to_json,
          headers: { content_type: 'application/json' }
        })
      end

      example 'it returns a 200 with an empty array' do
        do_request

        expect(status).to eq(200)
        expect(response_body).to eq([].to_json)
        expect(response_headers['Content-Type'].include?('application/html')).to eq(true)
      end
    end
  end
end
