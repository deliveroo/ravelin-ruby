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
                  :cvv_result_code,
                  :type,
                  :time,
                  :three_d_secure

    attr_required :transaction_id,
                  :currency,
                  :debit,
                  :credit,
                  :gateway,
                  :gateway_reference,
                  :success

    def initialize(params)
      three_d_secure_data = params['3ds']
      unless three_d_secure_data.nil?
        self.three_d_secure = three_d_secure_data
        params.delete('3ds')
      end

      super(params)
    end
  end
end
