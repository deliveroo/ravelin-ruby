module Ravelin
  class Chargeback < RavelinObject
    attr_accessor :chargeback_id,
      :gateway,
      :gateway_reference,
      :reason,
      :status,
      :amount,
      :currency,
      :dispute_time,
      :custom

    attr_required :chargeback_id, :gateway, :gateway_reference
  end
end
