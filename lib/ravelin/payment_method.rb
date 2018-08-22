module Ravelin
  class PaymentMethod < RavelinObject
    attr_accessor :payment_method_id,
      :nick_name,
      :method_type,
      :banned,
      :active,
      :registration_time,
      # Only when type = card
      :instrument_id,
      :name_on_card,
      :card_bin,
      :card_last_four,
      :card_type,
      :expiry_month,
      :expiry_year,
      :successful_registration,
      :prepaid_card,
      :issuer,
      :country_issued,
      # Only when type = paypal
      :email,
      :custom,
      :e_wallet

    attr_required :payment_method_id, :method_type
  end
end
