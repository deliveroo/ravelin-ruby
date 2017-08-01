module Ravelin
  class Tag
    def initialize(payload:)
      @payload = convert_to_ravelin_objects(payload)
    end

    def serializable_hash
      hash_map(payload) do |k, v|
        k = Ravelin.camelize(k)

        [k, v]
      end
    end

    private

    attr_accessor :payload

    def convert_to_ravelin_objects(payload)
      hash_map(payload) do |k, v|
        k = k.to_sym
        v = Ravelin.convert_ids_to_strings(k, v)

        [k, v]
      end
    end

    def hash_map(hash, &block)
      Hash[hash.map { |k, v| block.call(k, v) }]
    end
  end
end
