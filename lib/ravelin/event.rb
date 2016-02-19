module Ravelin
  class Event
    attr_accessor :name, :timestamp, :payload

    def initialize(name:, payload:, timestamp: nil)
      @name = name.to_sym
      @payload = convert_to_ravelin_objects(payload)
      @timestamp = timestamp.nil? ? Time.now.to_i : convert_to_epoch(timestamp)

      validate_top_level_payload_params
    end

    def serialize
      payload_hash = hash_map(self.payload) do |k, v|
        k = Ravelin.camelize(k)

        if v.is_a?(Ravelin::RavelinObject)
          [k, v.serialize]
        elsif v.is_a?(Array)
          [k, v.map(&:serialize)]
        else
          [k, v]
        end
      end

      return payload_hash.merge('timestamp' => timestamp)
    end

    def self.list_object_classes
      {
        items: Item
      }
    end

    def self.object_classes
      {
        chargeback:     Chargeback,
        customer:       Customer,
        device:         Device,
        item:           Item,
        location:       Location,
        order:          Order,
        payment_method: PaymentMethod,
        transaction:    Transaction
      }
    end

    private

    def validate_top_level_payload_params
      validate_customer_presence_on :order, :items, :paymentmethod,
        :pretransaction, :transaction

      case self.name
        when :items
          validate_payload_inclusion_of :order_id
        when :pretransaction, :transaction
          validate_payload_inclusion_of :order_id, :payment_method_id
        when :login
          validate_payload_inclusion_of :customer_id, :temp_customer_id
        when :checkout
          validate_payload_inclusion_of :customer, :order, :items,
            :payment_method, :transaction
      end
    end

    def validate_customer_presence_on(*events)
      if events.include?(self.name) && !payload_customer_reference_present?
        argument_error(%q{payload missing customer_id or temp_customer_id parameter})
      end
    end

    def validate_payload_inclusion_of(*required_keys)
      missing = required_keys - self.payload.keys

      if missing.any?
        argument_error(%Q{payload missing parameters: #{missing.join(', ')}})
      end
    end

    def payload_customer_reference_present?
      self.payload.keys.any? {|k| %i(customer_id temp_customer_id).include? k }
    end

    def argument_error(msg)
      raise ArgumentError.new(msg)
    end

    def convert_to_epoch(time)
      if time.is_a?(Time)
        time.to_i
      elsif time.is_a?(DateTime) && time.responds_to?(:to_i)
        time.to_i
      elsif time.is_a?(Integer)
        time
      else
        raise TypeError.new(%Q{timestamp requires a Time or epoch Integer})
      end
    end

    def convert_to_ravelin_objects(payload)
      hash_map(payload) do |k, v|
        k = k.to_sym

        if v.is_a?(Array) && klass = self.class.list_object_classes[k]
          [k, v.map { |item| klass.new(item) }]
        elsif v.is_a?(Hash) && klass = self.class.object_classes[k]
          [k, klass.new(v)]
        else
          [k, v]
        end
      end
    end

    def hash_map(hash, &block)
      Hash[hash.map { |k, v| block.call(k, v) }]
    end
  end
end
