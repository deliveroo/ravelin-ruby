module Ravelin
  class Customer < RavelinObject
    attr_accessor :customer_id, :email
    required_attributes :customer_id
  end
end
