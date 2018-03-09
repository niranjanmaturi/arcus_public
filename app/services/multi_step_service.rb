class MultiStepService
  DEFAULT_HTTP_METHOD = 'get'

  def initialize(device, template, parameters)
    @device   = device
    @template = template
    @parameters = parameters
  end

  def results
    add_device_parameters
    apply_all_steps
  end

  def add_device_parameters
    @parameters['username'] = @device.username || ''
    @parameters['password'] = @device.password || ''
  end

  def apply_all_steps
    @device.device_type.steps.map { |step| apply_step(step) }.find { |result| result }
  end

  def apply_step(step)
    request = build_step_request(step)
    response = make_request(request)
    extract_all_variables(step, response)

    return unless step.apply_template?

    response_doc    = parse_as_document(response)
    transformed_doc = transform(response_doc)
    transformed_obj = document_to_object(transformed_doc)
    results = extract_transformation_results(transformed_obj)
    validate_results!(results)
    results
  end

  def build_step_request(step)
    request_base = create_base_request
    request_with_options = add_options_to_request(step.request_option, request_base)

    if step.apply_template
      add_options_to_request(@template.request_option, request_with_options)
    else
      request_with_options
    end
  end

  def create_base_request
    {
      url: @device.base_url,
      http_method: DEFAULT_HTTP_METHOD,
      verify: @device.ssl_validation
    }
  end

  def add_options_to_request(request_option, request_hash)
    request_hash_with_url = add_url_to_request(request_option, request_hash)
    request_hash_with_http_method = add_http_method_to_request(request_option, request_hash_with_url)
    request_hash_with_basic_auth = add_basic_auth_to_request(request_option, request_hash_with_http_method)
    request_hash_with_body = add_body_to_request(request_option, request_hash_with_basic_auth)
    add_all_headers_to_request(request_option, request_hash_with_body)
  end

  def add_url_to_request(request_option, request_hash)
    return request_hash unless request_option.url?

    assembled_url = join_url(@device.base_url, request_option.url)
    parsed_url = ParsingService.parse_url(assembled_url, @parameters)
    request_hash.merge(url: parsed_url)
  end

  def join_url(base_url, relative_path)
    base_stub = base_url.gsub(/\/$/, '')
    relative_stub = relative_path.gsub(/^\//, '')
    [base_stub, relative_stub].join('/')
  end

  def add_http_method_to_request(request_option, request_hash)
    return request_hash unless request_option.http_method?
    request_hash.merge(http_method: request_option.http_method)
  end

  def add_basic_auth_to_request(request_option, request_hash)
    case request_option.basic_auth
    when true
      request_hash.merge(basic_auth: { username: @device.username, password: @device.password })
    when false
      request_hash.except(:basic_auth)
    else
      request_hash
    end
  end

  def add_body_to_request(request_option, request_hash)
    return request_hash unless request_option.body?

    parsed_body = ParsingService.parse(request_option.body, @parameters)
    request_hash.merge(body: parsed_body)
  end

  def add_all_headers_to_request(request_option, request_hash)
    request_option.headers.each do |header|
      request_hash = add_header_to_request(header, request_hash)
    end
    request_hash
  end

  def add_header_to_request(header, request_hash)
    parsed_name = ParsingService.parse(header.name, @parameters)
    parsed_value = ParsingService.parse(header.value, @parameters)
    request_hash.deep_merge(headers: { parsed_name => parsed_value })
  end

  def make_request(request)
    response = RequestClient.request(request[:http_method], request[:url], request.except(:http_method, :url))
    if response.code >= 400
      uri = URI.parse(request[:url])
      Rails.logger.warn({
        message: 'Server returned error when making query',
        request: request,
        response: {
          code: response.code,
          body: response.body
        }
      }.to_json)
      raise ArcusErrors::DataSourceError, "Error: Received HTTP code #{response.code} when querying #{uri.hostname} via #{uri.scheme}"
    end
    response
  rescue SocketError, Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNREFUSED, OpenSSL::SSL::SSLError => e
    uri = URI.parse(request[:url])
    Rails.logger.warn({
      message: 'Server failed to connect when making query',
      exception: {
        name: e.class.name,
        message: e.message,
      },
      request: request
    }.to_json)
    message = case e
              when Net::OpenTimeout, Net::ReadTimeout
                'Connection timeout'
              when Errno::ECONNREFUSED
                'Connection refused'
              when OpenSSL::SSL::SSLError
                'SSL validation failed'
              else
                'Host not found'
              end
    raise ArcusErrors::HostNotFound, "Error: #{message} when querying #{uri.hostname} via #{uri.scheme}"
  end

  def extract_all_variables(step, response)
    step.step_variables.each { |variable| extract_variable(variable, response) }
  end

  def extract_variable(variable, response)
    parsed_name = ParsingService.parse(variable.name, @parameters)
    parsed_value = ParsingService.parse(variable.value, @parameters)

    @parameters[parsed_name] = case variable.source_type
    when 'string'
      parsed_value
    when 'header'
      response.headers[parsed_value]
    when 'xpath'
      Nokogiri::XML(response.body).xpath(parsed_value).to_s
    when 'jsonpath'
      JsonPath.new(parsed_value).on(response.body).first
    else
      raise ArcusErrors::UnknownVariableSourceType, "Unknown type #{variable.source_type}"
    end
  end

  def parse_as_document(response)
    xml = begin
      parsed_json = JSON.parse(response.body)
      puts "\n\nParsed JSON: #{JSON.pretty_generate parsed_json}\n\n" unless Rails.env.test?
      safe_json = XmlPurifierService.new(parsed_json).encoded_json_document
      safe_json.to_xml(root: :root)
    rescue JSON::ParserError
      response.body
    end

	puts "\n\nConverted XML: #{xml}\n\n" unless Rails.env.test?
    Nokogiri::XML(xml)
  end

  def transform(document)
    xslt = Nokogiri::XSLT(@template.transformation)
    xslt.transform(document)
  rescue RuntimeError => e
    Rails.logger.warn({
      message: 'Failed running transformation',
      exception: {
        name: e.class.name,
        message: e.message
      },
      transformation: @template.transformation
    }.to_json)
    raise ArcusErrors::TransformationError, "Error applying transform: #{e.message.chomp}"
  end

  def document_to_object(document)
    if !document.root || document.root.name != 'root'
      raise ArcusErrors::MissingRootError, 'Error parsing transformation result. Missing root element <root>'
    end
    document.remove_namespaces!
    xml = document.to_s
    Hash.from_xml(xml)
  rescue REXML::ParseException => e
    Rails.logger.warn({
      message: 'Failed to parse transformation result',
      exception: {
        name: e.class.name,
        message: e.message,
      },
      document: xml
    }.to_json)

    raise ArcusErrors::TransformationError, 'Error parsing transformation result'
  end

  def extract_transformation_results(transformed)
    root = transformed['root'] || {}
    [ root['results'] || [] ].flatten
  end

  def validate_results!(results)
    if results.any? { |result| !result.is_a?(Hash) }
      raise ArcusErrors::TransformationError, 'Error parsing transformation result. Each <results> element requires a child <data> element and a child <label> element'
    end
    if results.any? { |result| !result.key?('data') }
      raise ArcusErrors::MissingDataError, 'Error parsing transformation result. Each <results> element requires a child <data> element'
    end
    if results.any? { |result| !result.key?('label') }
      raise ArcusErrors::MissingLabelError, 'Error parsing transformation result. Each <results> element requires a child <label> element'
    end
  end
end
