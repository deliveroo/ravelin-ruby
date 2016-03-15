module Ravelin
  class Event
    attr_accessor :name, :timestamp, :payload

    def initialize(name:, payload:, timestamp: nil)
      @name = convert_event_name(name)
      @payload = convert_to_ravelin_objects(payload)
      @timestamp = timestamp.nil? ? Time.now.to_i : convert_to_epoch(timestamp)

      validate_top_level_payload_params
    end

    def serializable_hash
      payload_hash = hash_map(self.payload) do |k, v|
        k = Ravelin.camelize(k)

        if v.is_a?(Ravelin::RavelinObject)
          [k, v.serializable_hash]
        else
          [k, v]
        end
      end

      payload_hash.merge('timestamp' => timestamp)
    end

    def object_classes
      {
        chargeback:     Chargeback,
        customer:       Customer,
        device:         Device,
        location:       Location,
        order:          Order,
        payment_method: PaymentMethod,
        transaction:    self.name == :pretransaction ? PreTransaction : Transaction
      }
    end

    private

    def validate_top_level_payload_params
      validate_customer_id_presence_on :order, :paymentmethod,
        :pretransaction, :transaction

      case self.name
        when :customer
          validate_payload_inclusion_of :customer
        when :pretransaction, :transaction
          validate_payload_inclusion_of :order_id, :payment_method_id
        when :login
          validate_payload_inclusion_of :customer_id, :temp_customer_id
        when :checkout
          validate_payload_inclusion_of :customer, :order,
            :payment_method, :transaction
      end
    end

    def validate_customer_id_presence_on(*events)
      if events.include?(self.name) && !payload_customer_reference_present?
        raise ArgumentError.
          new(%q{payload missing customer_id or temp_customer_id parameter})
      end
    end

    def validate_payload_inclusion_of(*required_keys)
      missing = required_keys - self.payload.keys

      if missing.any?
        raise ArgumentError.
          new(%Q{payload missing parameters: #{missing.join(', ')}})
      end
    end

    def payload_customer_reference_present?
      self.payload.keys.any? {|k| %i(customer_id temp_customer_id).include? k }
    end

    def convert_to_epoch(val)
      if val.is_a?(Time) || val.is_a?(Date) || val.is_a?(DateTime)
        Ravelin.datetime_to_epoch(val)
      elsif val.is_a?(Integer)
        val
      else
        raise TypeError.new(%Q{timestamp requires a Time or epoch Integer})
      end
    end

    def convert_to_ravelin_objects(payload)
      hash_map(payload) do |k, v|
        k = k.to_sym
        v = Ravelin.convert_ids_to_strings(k, v)

        if v.is_a?(Hash) && klass = object_classes[k]
          [k, klass.new(v)]
        else
          [k, v]
        end
      end
    end

    def convert_event_name(str)
      underscore_mapping = {
        payment_method: :paymentmethod,
        pre_transaction: :pretransaction
      }

      underscore_mapping.fetch(str.to_sym, str.to_sym)
    end

    def hash_map(hash, &block)
      Hash[hash.map { |k, v| block.call(k, v) }]
    end
  end
end
