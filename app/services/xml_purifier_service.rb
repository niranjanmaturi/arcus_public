class XmlPurifierService

  # from https://www.w3schools.com/xml/xml_elements.asp
  #
  # XML elements must follow these naming rules:
  #
  # Element names are case-sensitive.
  # Element names must start with a letter or underscore.
  # Element names cannot start with the letters xml (or XML, or Xml, etc)
  # Element names can contain letters, digits, hyphens, underscores, and periods.
  # Element names cannot contain spaces.

  DELIMITER = 'ö'
  START_WITH_SYMBOLS = HashWithIndifferentAccess.new({
    "0" => "#{DELIMITER}zero#{DELIMITER}",
    "1" => "#{DELIMITER}one#{DELIMITER}",
    "2" => "#{DELIMITER}two#{DELIMITER}",
    "3" => "#{DELIMITER}three#{DELIMITER}",
    "4" => "#{DELIMITER}four#{DELIMITER}",
    "5" => "#{DELIMITER}five#{DELIMITER}",
    "6" => "#{DELIMITER}six#{DELIMITER}",
    "7" => "#{DELIMITER}seven#{DELIMITER}",
    "8" => "#{DELIMITER}eight#{DELIMITER}",
    "9" => "#{DELIMITER}nine#{DELIMITER}",
    "." => "#{DELIMITER}period#{DELIMITER}",
    "_" => "#{DELIMITER}underscore#{DELIMITER}",
    "-" => "#{DELIMITER}minus#{DELIMITER}",
    })

  ANYWHERE_SPECIAL_SYMBOLS = HashWithIndifferentAccess.new ({
    " " => "#{DELIMITER}space#{DELIMITER}",
    "!" => "#{DELIMITER}exclamationMark#{DELIMITER}",
    "\"" => "#{DELIMITER}doubleQuote#{DELIMITER}",
    "#" => "#{DELIMITER}number#{DELIMITER}",
    "$" => "#{DELIMITER}dollar#{DELIMITER}",
    "%" => "#{DELIMITER}percent#{DELIMITER}",
    "&" => "#{DELIMITER}ampersand#{DELIMITER}",
    "'" => "#{DELIMITER}singleQuote#{DELIMITER}",
    "(" => "#{DELIMITER}leftParenthesis#{DELIMITER}",
    ")" => "#{DELIMITER}rightParenthesis#{DELIMITER}",
    "*" => "#{DELIMITER}asterisk#{DELIMITER}",
    "+" => "#{DELIMITER}plus#{DELIMITER}",
    "," => "#{DELIMITER}comma#{DELIMITER}",
    "/" => "#{DELIMITER}slash#{DELIMITER}",
    ":" => "#{DELIMITER}colon#{DELIMITER}",
    ";" => "#{DELIMITER}semicolon#{DELIMITER}",
    "<" => "#{DELIMITER}lessThan#{DELIMITER}",
    "=" => "#{DELIMITER}equalitySign#{DELIMITER}",
    ">" => "#{DELIMITER}greaterThan#{DELIMITER}",
    "?" => "#{DELIMITER}questionMark#{DELIMITER}",
    "@" => "#{DELIMITER}atSign#{DELIMITER}",
    "[" => "#{DELIMITER}leftSquareBracket#{DELIMITER}",
    "\\" => "#{DELIMITER}backslash#{DELIMITER}",
    "]" => "#{DELIMITER}rightSquareBracket#{DELIMITER}",
    "^" => "#{DELIMITER}circumflex#{DELIMITER}",
    "`" => "#{DELIMITER}accent#{DELIMITER}",
    "{" => "#{DELIMITER}leftCurlyBracket#{DELIMITER}",
    "|" => "#{DELIMITER}verticalBar#{DELIMITER}",
    "}" => "#{DELIMITER}rightCurlyBracket#{DELIMITER}",
    "~" => "#{DELIMITER}tilde#{DELIMITER}"
  })

  def initialize(json)
    @original_json_document = json.dup
    @encoded_json_document = nil
  end

  def encoded_json_document
    @encoded_json_document ||= substitute_special_characters!(@original_json_document.dup)
    # puts "JSON encoded: #{@encoded_json_document}"
    @encoded_json_document
  end

  private
  def substitute_special_characters!(json, parent = nil)
    if json.is_a?(Array)
      json.each do |json_hash|
        substitute_special_characters!(json_hash, nil)
      end
    elsif json.is_a?(Hash)
      json.keys.each do |key|
        value = json[key]
        substitute_special_characters!(value, key)

        ANYWHERE_SPECIAL_SYMBOLS.each do |special_symbol, substitute|
          if key.include? special_symbol
            new_key = key.gsub(special_symbol, substitute)
            # puts "'#{key}' contains symbol '#{special_symbol}' - substituting with '#{substitute}' and now becomes #{new_key}"

            json[new_key] = value
            json.except! key
            key = new_key
          end
        end

        START_WITH_SYMBOLS.each do |special_symbol, substitute|
          if key.start_with? special_symbol
            new_key = key.gsub(/#{Regexp.new("\\A#{special_symbol}")}/, substitute)
            # puts "'#{key}' starts with symbol '#{special_symbol}' - substituting with '#{substitute}' and now becomes #{new_key}"

            json[new_key] = value
            json.except! key
          end
        end
      end
    end

    json
  end
end
