module WhitespaceTrim
  def WhitespaceTrim.included(klass)
    klass.before_validation :global_whitespace_fix
    klass.class_eval do
      def self.trim_before_validation(*args)
        @fields_to_trim = args
      end

      def self.fields_to_trim
        @fields_to_trim || []
      end

      def global_whitespace_fix
        self.class.fields_to_trim.each do |field_name|
          send("#{field_name}=", send(field_name)&.strip)
        end
      end
    end
  end
end
