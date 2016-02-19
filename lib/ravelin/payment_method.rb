module Ravelin
  class PaymentMethod < RavelinObject
    attr_accessor :payment_method_id,
      :nick_name,
      :method_type,
      :banned,
      :active,
      :registration_time,
      :custom

    attr_required :payment_method_id, :method_type
  end
end
