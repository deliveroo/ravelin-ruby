module Ravelin
  class RavelinObject
    class << self
      attr_reader :attributes

      def required_attributes
        @required_attributes ||= []
      end

      def attr_required(*names)
        @required_attributes = *names
      end

      def attr_accessor(*names)
        @attributes ||= []
        @attributes.concat(names)
        super
      end
    end

    def initialize(**args)
      args.each do |key, value|
        self.send("#{key}=", value)
      end

      validate
    end

    def validate
      missing = self.class.required_attributes.select do |name|
        self.send(name).nil? || self.send(name) == ''
      end

      if missing.any?
        raise ArgumentError.new(%Q{missing parameters: #{missing.join(', ')}})
      end
    end

    def serialize
      self.class.attributes.each_with_object({}) do |key, hash|
        value = self.send(key)
        key = Ravelin.camelize(key)

        if value.is_a?(RavelinObject)
          hash[key] = value.serialize
        elsif !value.nil?
          hash[key] = value
        end
      end
    end
  end
end
