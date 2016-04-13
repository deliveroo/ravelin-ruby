module Ravelin
  class Transaction < RavelinObject
    attr_accessor :transaction_id,
      :email,
      :currency,
      :debit,
      :credit,
      :gateway,
      :custom,
      :success,
      :auth_code,
      :decline_code,
      :gateway_reference,
      :avs_result_code,
      :cvv_result_code

    attr_required :currency,
      :debit,
      :credit,
      :gateway,
      :gateway_reference,
      :success
  end
end
