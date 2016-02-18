module Ravelin
  class Event
    attr_accessor :name, :payload

    def initialize(name:, payload:)
      @name = name
      @payload = convert_to_ravelin_objects(payload)
    end

    def to_hash
      hash_map(self.payload) do |k, v|
        v.is_a?(Ravelin::RavelinObject) ? [k, v.to_hash] : [k, v]
      end
    end

    def self.object_classes
      # TODO - Add all the API event classes
      {
        customer: Customer
      }
    end

    private

    def convert_to_ravelin_objects(payload)
      hash_map(payload) do |k,v|
        if v.is_a?(Hash) && self.class.object_classes.has_key?(k)
          [k, self.class.object_classes[k].new(v)]
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
