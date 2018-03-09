if defined?(RspecApiDocumentation)
  ENV['RAILS_ENV'] = 'test'
  RspecApiDocumentation.configure do |config|
    config.format = [:markdown]
    config.api_name = 'Arcus'
  end

  module RspecApiDocumentation
    module Views
      class MarkupExample
        def special_chars
          '<>:"\'/\|?*'
        end

        def dirname
          ([resource_name.to_s.downcase.gsub(/\s+/, '_').tr(':', '_')] + description_array[0..-2]).map do |elem|
            elem.downcase.gsub(/\s+/, '_').tr(special_chars, '')
          end.join(File::SEPARATOR)
        end

        def filename
          basename = description_array[-1].downcase.gsub(/\s+/, '_').tr(special_chars, '')
          "#{basename}.#{extension}"
        end
      end
    end
  end

  module RspecApiDocumentation
    class Example
      def description
        description_array.join(' - ')
      end

      def description_array
        output = []
        example_group = metadata
        while example_group[:example_group]
          output.unshift example_group[:description_args].first
          example_group = example_group[:example_group]
        end
        output
      end
    end
  end
end
