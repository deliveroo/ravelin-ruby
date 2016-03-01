module Ravelin
  class RavelinObject
    class << self
      attr_reader :attr_accessor_names

      def required_attributes
        @required_attributes ||= []
      end

      def attr_required(*names)
        @required_attributes = *names
      end

      def attr_accessor(*names)
        @attr_accessor_names ||= []
        @attr_accessor_names.concat(names)
        super
      end
    end

    def initialize(**args)
      args.each do |key, value|
        self.send("#{key}=", convert_ids_to_strings(key, value))
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

    def serializable_hash
      self.class.attr_accessor_names.each_with_object({}) do |key, hash|
        value = self.send(key)
        key = Ravelin.camelize(key)

        if value.is_a?(RavelinObject)
          hash[key] = value.serializable_hash
        elsif value.is_a?(Array)
          hash[key] = value.map(&:serializable_hash)
        elsif value.is_a?(Time) || value.is_a?(Date) || value.is_a?(DateTime)
          hash[key] = Ravelin.datetime_to_epoch(value)
        elsif !value.nil?
          hash[key] = value
        end
      end
    end

    private

    def convert_ids_to_strings(key, value)
      key.to_s.match(/_id\Z/) && value.is_a?(Integer) ? value.to_s : value
    end
  end
end
