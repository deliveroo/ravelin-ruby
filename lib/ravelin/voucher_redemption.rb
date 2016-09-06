module Ravelin
  class VoucherRedemption < RavelinObject
    attr_accessor :payment_method_id,
      :voucher_code,
      :referrer_id,
      :expiry,
      :value,
      :currency,
      :voucher_type,
      :redemption_time,
      :success,
      :failure_source,
      :failure_reason,
      :custom

    attr_required :payment_method_id, :voucher_code, :referrer_id, :value, :currency, :voucher_type, :redemption_time, :success

    def location=(obj)
      @location = Ravelin::Location.new(obj)
    end
  end
end

