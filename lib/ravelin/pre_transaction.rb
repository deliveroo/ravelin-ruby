module Ravelin
  class PreTransaction < RavelinObject
    attr_accessor :transaction_id,
      :email,
      :currency,
      :debit,
      :credit,
      :gateway,
      :type,
      :time,
      :custom

    attr_required :transaction_id, :currency, :debit, :credit
  end
end
