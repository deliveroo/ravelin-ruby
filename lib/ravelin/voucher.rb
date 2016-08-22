module Ravelin
  class Voucher < RavelinObject
    attr_accessor :voucher_id,
      :voucher_code,
      :referrer_id,
      :expiry,
      :value,
      :currency,
      :voucher_type,
      :referral_value,
      :creation_time,
      :custom

    attr_required :voucher_code, :referrer_id, :expiry, :value, :currency, :voucher_type, :referral_value, :creation_time

    def location=(obj)
      @location = Ravelin::Location.new(obj)
    end
  end
end
