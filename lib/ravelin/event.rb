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
      payload_hash = hash_map(payload) do |k, v|
        k = Ravelin.camelize(k)

        if v.is_a?(Ravelin::RavelinObject)
          [k, v.serializable_hash]
        else
          [k, v]
        end
      end

      payload_hash.merge('timestamp' => format_timestamp(timestamp))
    end

    def object_classes
      {
        ato_login:      AtoLogin,
        authentication_mechanism: AuthenticationMechanism,
        chargeback:     Chargeback,
        customer:       Customer,
        ato_reclaim:    AtoReclaim,
        device:         Device,
        location:       Location,
        login:          Login,
        order:          Order,
        password:       Password,
        payment_method: PaymentMethod,
        voucher_redemption: VoucherRedemption,
        transaction:    name == :pretransaction ? PreTransaction : Transaction,
        label:          Label,
        voucher:        Voucher,
      }
    end

    def format_timestamp(timestamp)
      case name
      when :login
        timestamp * 1000
      when :reclaim
        Time.at(timestamp).utc.to_datetime.to_s
      else
        timestamp
      end
    end

    private

    def validate_top_level_payload_params
      validate_customer_id_presence_on :order, :paymentmethod,
        :pretransaction, :transaction, :label
      case name
      when :customer
        validate_payload_inclusion_of :customer
      when :voucher
        validate_payload_inclusion_of :voucher
      when :'paymentmethod/voucher'
        validate_payload_inclusion_of :'voucher_redemption'
      when :pretransaction, :transaction
        validate_payload_must_include_one_of(
          :payment_method_id, :payment_method
        )
        validate_payload_inclusion_of :order_id
      when :checkout
        validate_payload_inclusion_of :customer, :order,
          :payment_method, :transaction
      when :reclaim
        validate_payload_inclusion_of :customers, :source
      end
    end

    def validate_customer_id_presence_on(*events)
      if events.include?(name) && !payload_customer_reference_present?
        raise ArgumentError, 'payload missing customer_id or temp_customer_id parameter'
      end
    end

    def validate_payload_inclusion_of(*required_keys)
      missing = required_keys - payload.keys

      if missing.any?
        raise ArgumentError, "payload missing parameters: #{missing.join(', ')}"
      end
    end

    def validate_payload_must_include_one_of(*mutually_exclusive_keys)
      intersection = mutually_exclusive_keys & payload.keys

      if intersection.size > 1
        raise ArgumentError, "parameters are mutally exclusive: #{mutually_exclusive_keys.join(', ')}"
      elsif intersection.empty?
        raise ArgumentError, "payload must include one of: #{mutually_exclusive_keys.join(', ')}"
      end
    end

    def payload_customer_reference_present?
      payload.keys.any? { |k| %i[customer_id temp_customer_id].include? k }
    end

    def convert_to_epoch(val)
      if val.is_a?(Time) || val.is_a?(Date) || val.is_a?(DateTime)
        Ravelin.datetime_to_epoch(val)
      elsif val.is_a?(Integer)
        val
      else
        raise TypeError, 'timestamp requires a Time or epoch Integer'
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
        pre_transaction: :pretransaction,
        ato_login: :login,
        ato_reclaim: :reclaim,
        label: 'label/customer'.to_sym
      }

      underscore_mapping.fetch(str.to_sym, str.to_sym)
    end

    def hash_map(hash, &block)
      Hash[hash.map { |k, v| block.call(k, v) }]
    end
  end
end
