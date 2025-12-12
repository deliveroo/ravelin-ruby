module Ravelin
  class OrderSupplier < RavelinObject
    attr_accessor :supplier_id,
    :type,
    :status,
    :fee,
    :debt,
    :tip,
    :currency

    attr_required :supplier_id, :type
  end
end
