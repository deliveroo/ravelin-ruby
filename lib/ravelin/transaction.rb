module Ravelin
  class Transaction < RavelinObject
    attr_accessor :transaction_id,
      :success,
      :email,
      :currency,
      :debit,
      :credit,
      :auth_code,
      :decline_code,
      :gateway,
      :gateway_reference,
      :avs_result_code,
      :cvv_result_code,
      :custom

    attr_required :transaction_id, :currency, :debit, :credit, :gateway
  end
end
