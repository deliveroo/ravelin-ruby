module Ravelin
  class Item < RavelinObject
    attr_accessor :sku,
      :name,
      :price,
      :currency,
      :brand,
      :upc,
      :category,
      :quantity,
      :custom

    attr_required :sku, :quantity
  end
end
