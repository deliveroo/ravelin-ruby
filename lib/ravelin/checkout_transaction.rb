module Ravelin
  # Represents a transaction as used in the checkout endpoint.
  # As such it can have all the fields of a regular Transaction but only requires the fields of PreTransaction
  class CheckoutTransaction < RavelinObject
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
                  :cvv_result_code,
                  :type,
                  :time,
                  :three_d_secure

    attr_required :transaction_id, :currency, :debit, :credit
  end
end
