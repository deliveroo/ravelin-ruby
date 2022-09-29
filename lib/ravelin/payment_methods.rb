module Ravelin
  class PaymentMethods < RavelinObject
    attr_reader :methods

    def initialize(methods)
      @methods = methods
    end

    def serializable_hash
      methods.map(&:serializable_hash)
    end
  end
end
