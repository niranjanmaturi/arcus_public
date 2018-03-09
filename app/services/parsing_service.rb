require 'erb'

class ParsingService
  @@function_regex = /\$\{(\w+)(?:\((\w+)\))?\}/

  def self.parse_url(input, parameters)
    parse(input, parameters, 'url')
  end

  def self.parse(input, parameters, default_function = nil)
    input.gsub(@@function_regex) do
      has_function = !Regexp.last_match[2].nil?
      if has_function
        function_name = Regexp.last_match[1]
        parameter_name = Regexp.last_match[2]
      else
        function_name = default_function
        parameter_name = Regexp.last_match[1]
      end

      unless parameters.key?(parameter_name)
        raise ArcusErrors::InvalidParameter, "missing parameter #{parameter_name}"
      end

      parameter_value = parameters[parameter_name]

      case function_name
      when 'url'
        ERB::Util.url_encode(parameter_value)
      when 'json'
        parameters[parameter_name].to_json[1..-2]
      when 'xml'
        parameters[parameter_name].encode(:xml => :attr)[1..-2]
      when nil
        parameter_value
      else
        raise ArcusErrors::InvalidFunction, "unsupported function #{function_name}. supported functions: url, json, xml"
      end
    end
  end

  def self.list_parameter_names(input)
    input.scan(@@function_regex).map { |match| match[1] || match[0] }.uniq
  end

  # use javascript style interpolation e.g. ${variable}
  def self.param_regex
    /\$\{(\w+)\}/
  end
end
