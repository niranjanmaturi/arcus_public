require 'rails_helper'

describe MultiStepService do
  let(:transformation) { Faker::Lorem.paragraph }
  let(:steps) { [] }
  let(:device_type) { build :device_type, steps: steps }
  let(:device) { build(:device, device_type: device_type) }
  let(:template) { build(:template, device_type: device_type, transformation: transformation) }
  let(:parameter_key) { Faker::Lorem.words(2).join }
  let(:parameter_value) { Faker::Lorem.words(2).join }
  let(:parameters) { { parameter_key => parameter_value} }

  subject { described_class.new(device, template, parameters) }

  context 'DEFAULT_HTTP_METHOD' do
    it 'is set to the correct value' do
      expect(described_class::DEFAULT_HTTP_METHOD).to eq('get')
    end
  end

  context '#results' do
    it 'returns the result of calling apply_all_steps' do
      results = double('results')
      expect(subject).to receive(:apply_all_steps).and_return(results)

      actual = subject.results

      expect(actual).to eq(results)
    end

    it 'calls add_device_parameters before apply_all_steps' do
      expect(subject).to receive(:add_device_parameters).ordered
      expect(subject).to receive(:apply_all_steps).ordered

      subject.results
    end
  end

  context '#add_device_parameters' do
    it 'keeps existing parameters' do
      subject.add_device_parameters
      expect(parameters).to include(parameter_key => parameter_value)
    end

    context 'when device.username has a value' do
      context 'when parameters.username is not already set' do
        it 'adds username to parameters' do
          subject.add_device_parameters
          expect(parameters).to include('username' => device.username)
        end
      end

      context 'when username parameter is already set' do
        let(:parameters) { { parameter_key => parameter_value, 'username' => Faker::Lorem.word } }

        it 'overrides username in parameters' do
          subject.add_device_parameters
          expect(parameters).to include('username' => device.username)
        end
      end
    end

    context 'when device.username is nil' do
      before do
        device.username = nil
      end

      context 'when parameters.username is not already set' do
        it 'adds username to parameters with empty string' do
          subject.add_device_parameters
          expect(parameters).to include('username' => '')
        end
      end

      context 'when username parameter is already set' do
        let(:parameters) { { parameter_key => parameter_value, 'username' => Faker::Lorem.word } }

        it 'adds username to parameters with empty string' do
          subject.add_device_parameters
          expect(parameters).to include('username' => '')
        end
      end
    end

    context 'when device.password is empty string' do
      before do
        device.username = ''
      end

      context 'when parameters.username is not already set' do
        it 'adds username to parameters with empty string' do
          subject.add_device_parameters
          expect(parameters).to include('username' => '')
        end
      end

      context 'when username parameter is already set' do
        let(:parameters) { { parameter_key => parameter_value, 'username' => Faker::Lorem.word } }

        it 'adds username to parameters with empty string' do
          subject.add_device_parameters
          expect(parameters).to include('username' => '')
        end
      end
    end

    context 'when device.password has a value' do
      context 'when parameters.password is not already set' do
        it 'adds password to parameters' do
          subject.add_device_parameters
          expect(parameters).to include('password' => device.password)
        end
      end

      context 'when password parameter is already set' do
        let(:parameters) { { parameter_key => parameter_value, 'password' => Faker::Lorem.word } }

        it 'overrides password in parameters' do
          subject.add_device_parameters
          expect(parameters).to include('password' => device.password)
        end
      end
    end

    context 'when device.password is nil' do
      before do
        device.password = nil
      end

      context 'when parameters.password is not already set' do
        it 'adds password to parameters with empty string' do
          subject.add_device_parameters
          expect(parameters).to include('password' => '')
        end
      end

      context 'when password parameter is already set' do
        let(:parameters) { { parameter_key => parameter_value, 'password' => Faker::Lorem.word } }

        it 'adds password to parameters with empty string' do
          subject.add_device_parameters
          expect(parameters).to include('password' => '')
        end
      end
    end

    context 'when device.password is empty string' do
      before do
        device.password = ''
      end

      context 'when parameters.password is not already set' do
        it 'adds password to parameters with empty string' do
          subject.add_device_parameters
          expect(parameters).to include('password' => '')
        end
      end

      context 'when password parameter is already set' do
        let(:parameters) { { parameter_key => parameter_value, 'password' => Faker::Lorem.word } }

        it 'adds password to parameters with empty string' do
          subject.add_device_parameters
          expect(parameters).to include('password' => '')
        end
      end
    end
  end

  context '#apply_all_steps' do
    let(:step1) { build(:step) }
    let(:step2) { build(:step) }
    let(:step3) { build(:step) }
    let(:steps) { [ step1, step2, step3 ] }

    it 'returns the correct result' do
      results = double('results')
      expect(subject).to receive(:apply_step).with(step1).and_return(nil).ordered
      expect(subject).to receive(:apply_step).with(step2).and_return(results).ordered
      expect(subject).to receive(:apply_step).with(step3).and_return(nil).ordered

      actual = subject.apply_all_steps
      expect(actual).to eq(results)
    end
  end

  context '#apply_step' do
    let(:step) { build(:step, apply_template: apply_template) }

    let(:request) { double 'request' }
    let(:response_object) { double 'response_object' }
    let(:response_document) { double 'response_document' }
    let(:transformed_document) { double 'transformed_document' }
    let(:transformed_object) { double 'transformed_object' }
    let(:results) { double 'results' }

    before do
      allow(subject).to receive(:build_step_request).with(step).and_return(request)
      allow(subject).to receive(:make_request).with(request).and_return(response_object)
      allow(subject).to receive(:extract_all_variables).with(step, response_object).and_return(double('extract_all_variables_result'))
    end

    context 'when step.apply_template is false' do
      let(:apply_template) { false }

      it 'returns nil' do
        actual = subject.apply_step(step)
        expect(actual).to eq(nil)
      end
    end

    context 'when step.apply_template is true' do
      let(:apply_template) { true }

      before do
        allow(subject).to receive(:parse_as_document).with(response_object).and_return(response_document)
        allow(subject).to receive(:transform).with(response_document).and_return(transformed_document)
        allow(subject).to receive(:document_to_object).with(transformed_document).and_return(transformed_object)
        allow(subject).to receive(:extract_transformation_results).with(transformed_object).and_return(results)
        allow(subject).to receive(:validate_results!).and_return(nil)
      end

      it 'returns result of extract_transformation_results' do
        actual = subject.apply_step(step)
        expect(actual).to eq(results)
      end
    end
  end

  context '#build_step_request' do
    let(:request_option) { build(:request_option) }
    let(:step) { build(:step, request_option: request_option, apply_template: apply_template) }
    let(:request_base) { double('request_base') }
    let(:request_with_options) { double('request_with_options') }
    let(:request_with_template) { double('request_with_template') }

    before do
      allow(subject).to receive(:create_base_request).with(no_args).and_return(request_base)
      allow(subject).to receive(:add_options_to_request).with(request_option, request_base).and_return(request_with_options)
      allow(subject).to receive(:add_options_to_request).with(template.request_option, request_with_options).and_return(request_with_template)
    end

    context 'when step.apply_template is false' do
      let(:apply_template) { false }

      it 'correctly builds a request without the template' do
        actual = subject.build_step_request(step)
        expect(actual).to eq(request_with_options)
      end
    end

    context 'when step.apply_template is true' do
      let(:apply_template) { true }

      it 'correctly builds a request with the template' do
        actual = subject.build_step_request(step)
        expect(actual).to eq(request_with_template)
      end
    end
  end

  context '#create_base_request' do
    let(:expected_reqeust_hash) do
      {
        url: device.base_url,
        http_method: described_class::DEFAULT_HTTP_METHOD,
        verify: device.ssl_validation
      }
    end

    it 'returns a hash with prepopulated attributes' do
      expect(subject.create_base_request).to eq(expected_reqeust_hash)
    end
  end

  context '#add_options_to_request' do
    let(:request_option) { build(:request_option) }
    let(:request_base) { double('request_base') }
    let(:request_with_url) { double('request_with_url') }
    let(:request_with_http_method) {double('request_with_http_method') }
    let(:request_with_basic_auth) { double('request_with_basic_auth') }
    let(:request_with_body) { double('request_with_body') }
    let(:request_with_headers) { double('request_with_headers') }

    before do
      allow(subject).to receive(:add_url_to_request).with(request_option, request_base).and_return(request_with_url)
      allow(subject).to receive(:add_http_method_to_request).with(request_option, request_with_url).and_return(request_with_http_method)
      allow(subject).to receive(:add_basic_auth_to_request).with(request_option, request_with_http_method).and_return(request_with_basic_auth)
      allow(subject).to receive(:add_body_to_request).with(request_option, request_with_basic_auth).and_return(request_with_body)
      allow(subject).to receive(:add_all_headers_to_request).with(request_option, request_with_body).and_return(request_with_headers)
    end

    it 'correctly builds a request' do
      actual = subject.add_options_to_request(request_option, request_base)
      expect(actual).to eq(request_with_headers)
    end
  end

  context '#add_url_to_request' do
    let(:request_option) { build(:request_option, url: request_option_url) }
    let(:pre_existing_key) { Faker::Lorem.word.to_sym }
    let(:pre_existing_value) { Faker::Lorem.word }
    let(:pre_existing_url) { Faker::Lorem.word }
    let(:request) { { pre_existing_key => pre_existing_value, url: pre_existing_url } }
    let(:assembled_url) { double 'assembled url' }
    before do
      allow(subject).to receive(:join_url).with(device.base_url, request_option_url).and_return(assembled_url)
    end

    context 'when request_option.url is empty' do
      let(:request_option_url) { '' }

      it 'does not set the URL property' do
        updated_request_hash = subject.add_url_to_request(request_option, request)

        expect(updated_request_hash).to eq(pre_existing_key => pre_existing_value, url: pre_existing_url)
      end
    end

    context 'when request_option.url has value' do
      let(:request_option_url) { Faker::Lorem.words(3).join('/') }
      let(:parser_result) { Faker::Lorem.word }

      it 'sets the URL property to concatenated url' do
        expect(ParsingService).to receive(:parse_url).with(assembled_url, parameters).and_return(parser_result)

        updated_request_hash = subject.add_url_to_request(request_option, request)

        expect(updated_request_hash).to eq(pre_existing_key => pre_existing_value, url: parser_result)
      end
    end
  end

  context '#join_url' do
    let(:base_piece) { "http://#{Faker::Lorem.words.join('/')}" }
    let(:relative_piece) { Faker::Lorem.words.join('/') }
    let(:proper_url) { [base_piece, relative_piece].join('/') }

    let(:join_url) { subject.join_url(base_url, relative_path) }

    context 'when base url ends with a slash' do
      let(:base_url) { "#{base_piece}/" }
      context 'when the relative piece begins with a slash' do
        let(:relative_path) { "/#{relative_piece}" }
        it { expect(join_url).to eq(proper_url) }
      end
      context 'when the relative piece does not begin with a slash' do
        let(:relative_path) { relative_piece }
        it { expect(join_url).to eq(proper_url) }
      end
    end
    context 'when base url does not end with a slash' do
      let(:base_url) { base_piece }
      context 'when the relative piece begins with a slash' do
        let(:relative_path) { "/#{relative_piece}" }
        it { expect(join_url).to eq(proper_url) }
      end
      context 'when the relative piece does not begin with a slash' do
        let(:relative_path) { relative_piece }
        it { expect(join_url).to eq(proper_url) }
      end
    end
  end

  context '#add_http_method_to_request' do
    let(:request_option) { build(:request_option, http_method: http_method) }
    let(:pre_existing_key) { Faker::Lorem.word.to_sym }
    let(:pre_existing_value) { Faker::Lorem.word }
    let(:pre_existing_http_method) { Faker::Lorem.word }
    let(:request) { { pre_existing_key => pre_existing_value, http_method: pre_existing_http_method } }

    context 'when request_option.http_method is empty' do
      let(:http_method) { '' }

      it 'does not set the http_method property' do
        updated_request_hash = subject.add_http_method_to_request(request_option, request)

        expect(updated_request_hash).to eq(pre_existing_key => pre_existing_value, http_method: pre_existing_http_method)
      end
    end

    context 'when request_option.http_method has value' do
      let(:http_method) { Faker::Lorem.word }

      it 'sets the http_method property' do
        updated_request_hash = subject.add_http_method_to_request(request_option, request)

        expect(updated_request_hash).to eq(pre_existing_key => pre_existing_value, http_method: http_method)
      end
    end
  end

  context '#add_basic_auth_to_request' do
    let(:request_option) { build(:request_option, basic_auth: basic_auth) }
    let(:pre_existing_key) { Faker::Lorem.word.to_sym }
    let(:pre_existing_value) { Faker::Lorem.word }
    let(:pre_existing_basic_auth) { { username: Faker::Lorem.word, password: Faker::Lorem.word } }
    let(:request) { { pre_existing_key => pre_existing_value, basic_auth: pre_existing_basic_auth } }

    context 'when request_option.basic_auth is nil' do
      let(:basic_auth) { nil }

      it 'does not change the basic_auth property' do
        updated_request_hash = subject.add_basic_auth_to_request(request_option, request)

        expect(updated_request_hash).to eq(pre_existing_key => pre_existing_value, basic_auth: pre_existing_basic_auth)
      end
    end

    context 'when request_option.basic_auth is true' do
      let(:basic_auth) { true }

      it 'does set the basic_auth property' do
        updated_request_hash = subject.add_basic_auth_to_request(request_option, request)

        expect(updated_request_hash).to eq(pre_existing_key => pre_existing_value, basic_auth: { username: device.username, password: device.password })
      end
    end

    context 'when request_option.basic_auth is false' do
      let(:basic_auth) { false }

      it 'does unsets the basic_auth property' do
        updated_request_hash = subject.add_basic_auth_to_request(request_option, request)

        expect(updated_request_hash).to eq(pre_existing_key => pre_existing_value)
      end
    end
  end

  context '#add_body_to_request' do
    let(:request_option) { build(:request_option, body: request_option_body) }
    let(:pre_existing_key) { Faker::Lorem.word.to_sym }
    let(:pre_existing_value) { Faker::Lorem.word }
    let(:pre_existing_body) { Faker::Lorem.word }
    let(:request) { { pre_existing_key => pre_existing_value, body: pre_existing_body } }

    context 'when request_option.body is empty' do
      let(:request_option_body) { '' }

      it 'does not set the body property' do
        updated_request_hash = subject.add_body_to_request(request_option, request)

        expect(updated_request_hash).to eq(pre_existing_key => pre_existing_value, body: pre_existing_body)
      end
    end

    context 'when request_option.body has value' do
      let(:request_option_body) { Faker::Lorem.words(3).join('/') }
      let(:parser_result) { Faker::Lorem.word }

      it 'sets the body property to parsed body' do
        expect(ParsingService).to receive(:parse).with(request_option_body, parameters).and_return(parser_result)

        updated_request_hash = subject.add_body_to_request(request_option, request)

        expect(updated_request_hash).to eq(pre_existing_key => pre_existing_value, body: parser_result)
      end
    end
  end

  context '#add_all_headers_to_request' do
    let(:header1) { build(:header) }
    let(:header2) { build(:header) }
    let(:header3) { build(:header) }
    let(:request_option) { build(:request_option, headers: [ header1, header2, header3 ]) }

    let(:request_hash_input) { double('request_hash_input') }
    let(:request_hash_with_header_1) { double('request_hash_with_header_1') }
    let(:request_hash_with_header_2) { double('request_hash_with_header_2') }
    let(:request_hash_with_header_3) { double('request_hash_with_header_3') }

    it 'returns the correct result' do
      results = double('results')
      expect(subject).to receive(:add_header_to_request).with(header1, request_hash_input).and_return(request_hash_with_header_1)
      expect(subject).to receive(:add_header_to_request).with(header2, request_hash_with_header_1).and_return(request_hash_with_header_2)
      expect(subject).to receive(:add_header_to_request).with(header3, request_hash_with_header_2).and_return(request_hash_with_header_3)

      actual = subject.add_all_headers_to_request(request_option, request_hash_input)
      expect(actual).to eq(request_hash_with_header_3)
    end
  end

  context '#add_header_to_request' do
    let(:name) { Faker::Lorem.word }
    let(:value) { Faker::Lorem.word }
    let(:header) { build(:header, name: name, value: value) }

    let(:pre_existing_key) { Faker::Lorem.word.to_sym }
    let(:pre_existing_value) { Faker::Lorem.word }

    let(:parsed_name) { Faker::Lorem.words(2).join }
    let(:parsed_value) { Faker::Lorem.words(2).join }

    before do
      expect(ParsingService).to receive(:parse).with(name, parameters).and_return(parsed_name)
      expect(ParsingService).to receive(:parse).with(value, parameters).and_return(parsed_value)
    end

    context 'when no headers are already present' do
      let(:request) { { pre_existing_key => pre_existing_value } }

      it 'adds a header to request' do
        updated_request_hash = subject.add_header_to_request(header, request)
        expect(updated_request_hash).to eq({
          pre_existing_key => pre_existing_value,
          headers: {
            parsed_name => parsed_value
          }
        })
      end
    end

    context 'when headers are already present' do
      let(:existing_header_name) { Faker::Lorem.words(2).join }
      let(:existing_header_value) { Faker::Lorem.words(2).join }
      let(:request) { { pre_existing_key => pre_existing_value, headers: { existing_header_name => existing_header_value } } }

      it 'adds a header to request' do
        updated_request_hash = subject.add_header_to_request(header, request)
        expect(updated_request_hash.size).to eq(2)
        expect(updated_request_hash[:headers].size).to eq(2)
        expect(updated_request_hash).to include({
          pre_existing_key => pre_existing_value,
          headers: {
            existing_header_name => existing_header_value,
            parsed_name => parsed_value
          }
        })
      end

      context 'with duplicate header name' do
        let(:parsed_name) { existing_header_name }

        it 'replaces the header in request' do
          updated_request_hash = subject.add_header_to_request(header, request)

          expect(updated_request_hash).to eq({
            pre_existing_key => pre_existing_value,
            headers: {
              existing_header_name => parsed_value
            }
          })
        end
      end
    end
  end

  context '#make_request' do
    let(:http_method) { double('http_method') }
    let(:url) { Faker::Internet.url }

    let(:extra_key_1) { Faker::Lorem.words(2).join }
    let(:extra_key_2) { Faker::Lorem.words(2).join }
    let(:extra_value_1) { double('extra_value_1') }
    let(:extra_value_2) { double('extra_value_2') }
    let(:response) { double('response', code: code, body: body) }
    let(:code) { 200 }
    let(:body) { Faker::Lorem.paragraph }

    let(:request) do
      {
        http_method: http_method,
        url: url,
        extra_key_1 => extra_value_1,
        extra_key_2 => extra_value_2,
      }
    end

    context 'when response.code = 200' do
      it 'calls RequestClient correctly' do
        expect(RequestClient).to receive(:request).with(http_method, url, { extra_key_1 => extra_value_1, extra_key_2 => extra_value_2 }).and_return(response)
        actual = subject.make_request(request)
        expect(actual).to eq(response)
      end
    end

    context 'when response.code >= 400' do
      let(:code) { Faker::Number.between(400, 599) }
      it 'calls RequestClient correctly' do
        expect(RequestClient).to receive(:request).with(http_method, url, { extra_key_1 => extra_value_1, extra_key_2 => extra_value_2 }).and_return(response)
        expect(Rails.logger).to receive(:warn) do |message|
          expect(message).to include('Server returned error when making query')
          expect(message).to include(url)
          expect(message).to include(code.to_s)
          expect(message).to include(body)
        end
        expect{ subject.make_request(request) }.to raise_error(ArcusErrors::DataSourceError)
      end
    end

    [SocketError, Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNREFUSED, OpenSSL::SSL::SSLError].each do |error_class|
      let(:error_message) { Faker::Lorem.sentence }

      context "when RequestClient.request raises #{error_class.name}" do
        it 'raises the proper error' do
          expect(RequestClient).to receive(:request).and_raise(error_class.new(error_message))
          expect(Rails.logger).to receive(:warn) do |message|
            expect(message).to include('Server failed to connect when making query')
            expect(message).to include(url)
            expect(message).to include(error_class.name)
            expect(message).to include(error_message)
          end
          expect{ subject.make_request(request) }.to raise_error(ArcusErrors::HostNotFound)
        end
      end
    end
  end

  context '#extract_all_variables' do
    let(:variable1) { build(:step_variable) }
    let(:variable2) { build(:step_variable) }
    let(:variable3) { build(:step_variable) }
    let(:step) { build(:step, step_variables: [ variable1, variable2, variable3]) }
    let(:response) { double('response') }

    it 'calls extract_variable in order' do
      expect(subject).to receive(:extract_variable).with(variable1, response).ordered
      expect(subject).to receive(:extract_variable).with(variable2, response).ordered
      expect(subject).to receive(:extract_variable).with(variable3, response).ordered

      subject.extract_all_variables(step, response)
    end
  end

  context '#extract_variable' do
    let(:name) { Faker::Lorem.words(3).join }
    let(:value) { Faker::Lorem.words(3).join }
    let(:parsed_name) { Faker::Lorem.word }
    let(:parsed_value) { Faker::Lorem.word }
    let(:variable) { build(:step_variable, name: name, value: value, source_type: source_type) }
    let(:response) { double('response') }

    before do
      allow(ParsingService).to receive(:parse).with(name, parameters).and_return(parsed_name)
      allow(ParsingService).to receive(:parse).with(value, parameters).and_return(parsed_value)
    end

    context 'when source_type == string' do
      let(:source_type) { 'string' }

      it 'adds value to parameters' do
        subject.extract_variable(variable, response)
        expect(parameters).to eq({
          parameter_key => parameter_value,
          parsed_name => parsed_value,
        })
      end
    end

    context 'when source_type == header' do
      let(:source_type) { 'header' }
      let(:header_value) { Faker::Lorem.word }

      it 'adds value to parameters from header' do
        expect(response).to receive(:headers).with(no_args).and_return({ parsed_value => header_value })

        subject.extract_variable(variable, response)

        expect(parameters).to eq({
          parameter_key => parameter_value,
          parsed_name => header_value,
        })
      end
    end

    context 'when source_type == xpath' do
      let(:source_type) { 'xpath' }
      let(:body) { Faker::Lorem.word }
      let(:nokogiri_document) { double('nokogiri_document') }
      let(:xpath_result) { double('xpath_result') }
      let(:expected) { Faker::Lorem.word }

      before do
        allow(response).to receive(:body).with(no_args).and_return(body)
        allow(Nokogiri::XML::Document).to receive(:parse).with(body, any_args).and_return(nokogiri_document)
        allow(nokogiri_document).to receive(:xpath).with(parsed_value).and_return(xpath_result)
        allow(xpath_result).to receive(:to_s).and_return(expected)
      end

      it 'adds value to parameters from body' do
        subject.extract_variable(variable, response)

        expect(parameters).to eq({
          parameter_key => parameter_value,
          parsed_name => expected
        })
      end
    end

    context 'when source_type == jsonpath' do
      let(:source_type) { 'jsonpath' }
      let(:body) { Faker::Lorem.word }
      let(:jsonpath_parser) { double 'jsonpath parser' }
      let(:expected) { Faker::Lorem.word }

      before do
        allow(response).to receive(:body).with(no_args).and_return(body)
        allow(JsonPath).to receive(:new).with(parsed_value).and_return(jsonpath_parser)
        allow(jsonpath_parser).to receive(:on).with(body).and_return([expected])
      end

      it 'adds value to parameters from body' do
        subject.extract_variable(variable, response)

        expect(parameters).to eq({
          parameter_key => parameter_value,
          parsed_name => expected
        })
      end
    end

    context 'when source_type is unknown' do
      let(:source_type) { Faker::Lorem.word }

      it 'raises an error' do
        expect { subject.extract_variable(variable, response) }.to raise_error(ArcusErrors::UnknownVariableSourceType)
      end
    end
  end

  context '#parse_as_document' do
    let(:response) { double('response', body: body) }
    let(:body) { double('body') }
    let(:document) { double('document') }

    context 'when passed a JSON response' do
      let(:parsed_json) { double('parsed_json') }
      let(:xml) { double('xml') }
      let(:xml_purifier) { double 'XmlPurifierService' }
      let(:safe_json) { double 'safe json' }

      let(:response_to_xml) { double('response_to_xml') }

      before do
        allow(JSON).to receive(:parse).with(body).and_return(parsed_json)
        allow(XmlPurifierService).to receive(:new).with(parsed_json).and_return(xml_purifier)
        allow(xml_purifier).to receive(:encoded_json_document).and_return(safe_json)
        allow(safe_json).to receive(:to_xml).with(root: :root).and_return(xml)
        allow(Nokogiri::XML::Document).to receive(:parse).with(xml, any_args).and_return(document)
      end

      it 'returns Nokogiri document based on parsed JSON' do
        expect(subject.parse_as_document(response)).to eq(document)
      end
    end

    context 'when passed an XML response' do
      before do
        allow(JSON).to receive(:parse).with(body).and_raise(JSON::ParserError)
        allow(Nokogiri::XML::Document).to receive(:parse).with(body, any_args).and_return(document)
      end

      it 'returns a Nokogiri document' do
        expect(subject.parse_as_document(response)).to eq(document)
      end
    end
  end

  context '#transform' do
    let(:document) { double 'document' }
    let(:xslt) { double 'xslt' }
    let(:output) { double 'output' }

    it 'transforms the xml passed in using an xslt' do
      allow(Nokogiri::XSLT).to receive(:parse).with(transformation, any_args).and_return(xslt)
      allow(xslt).to receive(:transform).with(document).and_return(output)

      expect(subject.transform(document)).to eq(output)
    end

    context 'transform failures' do
      let(:error_class) { RuntimeError }
      let(:error_message) { Faker::Lorem.words(3).join }

      it 'return the XSLT error message when unable to transform' do
        allow(Nokogiri::XSLT).to receive(:parse).with(transformation, any_args).and_return(xslt)
        allow(xslt).to receive(:transform).with(document).and_raise(error_class, error_message)

        expect(Rails.logger).to receive(:warn) do |message|
          expect(message).to include('Failed running transformation')
          expect(message).to include(transformation)
          expect(message).to include(error_class.name)
          expect(message).to include(error_message)
        end

        expect { subject.transform(document) }.to raise_error(ArcusErrors::TransformationError, "Error applying transform: #{error_message}")
      end
    end
  end

  context '#document_to_object' do
    let(:document) { double 'document', root: root_obj }
    let(:root_obj) { double 'root obj', name: root_name }
    let(:root_name) { 'root' }
    let(:xml_string) { Faker::Lorem.paragraph }

    before do
      allow(document).to receive(:to_s).and_return(xml_string)
      allow(document).to receive(:remove_namespaces!)
    end

    context 'when document has root element' do
      let(:object) { double('object') }

      it 'calls the request service and calls the transform' do
        allow(Hash).to receive(:from_xml).with(xml_string).and_return(object)

        expect(subject.document_to_object(document)).to eq(object)
      end
    end

    context 'when document has incorrect root element' do
      let(:root_name) { Faker::Lorem.words(2).join('-') }

      it 'calls the request service and calls the transform' do

        expect{ subject.document_to_object(document) }.to raise_error(ArcusErrors::MissingRootError)
      end
    end

    context 'when document cannot be parsed' do
      let(:error_message) { Faker::Lorem.sentence }
      let(:error_class) { REXML::ParseException }

      it 'raises TransformationError' do
        allow(Hash).to receive(:from_xml).with(xml_string).and_raise(error_class, error_message)

        expect(Rails.logger).to receive(:warn) do |message|
          expect(message).to include('Failed to parse transformation result')
          expect(message).to include(xml_string)
          expect(message).to include(error_class.name)
          expect(message).to include(error_message)
        end

        expect { subject.document_to_object(document) }.to raise_error(ArcusErrors::TransformationError, 'Error parsing transformation result')
      end
    end
  end

  context '#extract_transformation_results' do
    let(:results) { double 'results' }

    let(:transformed) do
      {
        'root' => {
          'results' => results
        }
      }
    end

    context 'when results is a single object' do
      it 'returns result of transformation in array' do
        actual = subject.extract_transformation_results(transformed)
        expect(actual).to eq([results])
      end
    end

    context 'when results is already an array' do
      let(:results) { [ double('results') ] }

      it 'returns result of transformation' do
        actual = subject.extract_transformation_results(transformed)
        expect(actual).to eq(results)
      end
    end

    context 'when data from device is nil' do
      let(:transformed) do
        {
          'data' => nil
        }
      end

      it 'returns an empty list' do
        actual = subject.extract_transformation_results(transformed)
        expect(actual).to eq([])
      end
    end
  end

  context '#validate_results!' do
    let(:results) { [] }

    context 'when empty' do
      it 'should not raise an error' do
        expect{ subject.validate_results!(results) }.not_to raise_error
      end
    end

    context 'when it contains non hash elements' do
      let(:results) { [ {}, dirty_object, {} ] }

      context 'a string' do
        let(:dirty_object) { 'string' }

        it 'should raise a transformation error' do
          expect{ subject.validate_results!(results) }.to raise_error(ArcusErrors::TransformationError)
        end
      end

      context 'a number' do
        let(:dirty_object) { 15 }

        it 'should raise a transformation error' do
          expect{ subject.validate_results!(results) }.to raise_error(ArcusErrors::TransformationError)
        end
      end

      context 'an array' do
        let(:dirty_object) { [] }

        it 'should raise a transformation error' do
          expect{ subject.validate_results!(results) }.to raise_error(ArcusErrors::TransformationError)
        end
      end

      context 'a nil' do
        let(:dirty_object) { [] }

        it 'should raise a transformation error' do
          expect{ subject.validate_results!(results) }.to raise_error(ArcusErrors::TransformationError)
        end
      end
    end

    context 'missing component elements' do
      let(:array_size) { 10 }

      let(:randomized_array_of_results) do
        Array.new(array_size) { |i| { data: i, label: "Label-#{i}"}.stringify_keys }.sort_by{ rand }
      end

      context 'missing data from one of the elements' do
        let(:results) { randomized_array_of_results[rand(array_size)].delete('data'); randomized_array_of_results }
        it 'should raise a missing data error' do
          expect{ subject.validate_results!(results) }.to raise_error(ArcusErrors::MissingDataError)
        end
      end

      context 'missing data from all of the elements' do
        let(:results) { randomized_array_of_results.each{|elem| elem.delete('data')}; randomized_array_of_results }
        it 'should raise a missing data error' do
          expect{ subject.validate_results!(results) }.to raise_error(ArcusErrors::MissingDataError)
        end
      end

      context 'missing label from one of the elements' do
        let(:results) { randomized_array_of_results[rand(array_size)].delete('label'); randomized_array_of_results }
        it 'should raise a missing label error' do
          expect{ subject.validate_results!(results) }.to raise_error(ArcusErrors::MissingLabelError)
        end
      end

      context 'missing label from all of the elements' do
        let(:results) { randomized_array_of_results.each{|elem| elem.delete('label')}; randomized_array_of_results }
        it 'should raise a missing label error' do
          expect{ subject.validate_results!(results) }.to raise_error(ArcusErrors::MissingLabelError)
        end
      end
    end
  end
end
