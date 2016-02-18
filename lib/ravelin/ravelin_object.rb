module Ravelin
  class RavelinObject
    class << self
      attr_reader :attributes

      def ravelin_required_attributes
        @ravelin_required_attributes ||= []
      end

      def required_attributes(*names)
        @ravelin_required_attributes = *names
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
      invalid_attrs = self.class.ravelin_required_attributes.select do |name|
        self.send(name).nil? || self.send(name) == ''
      end

      errors = invalid_attrs.map do |a|
        %Q{"#{a}" can't be blank for #{self.class.name}}
      end

      raise InvalidParametersError.new(errors.join(', ')) if errors.any?
    end

    def to_hash
      self.class.attributes.each_with_object({}) do |key, hash|
        hash[camelize(key)] = self.send(key) unless self.send(key).nil?
      end
    end

    private

    def camelize(str)
      str.to_s.gsub(/_(.)/) { |e| $1.upcase }
    end
  end
end
