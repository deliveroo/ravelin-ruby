module Ravelin
  class Order < RavelinObject
    attr_accessor :order_id,
      :email,
      :price,
      :currency,
      :seller_id,
      :items,
      :from,
      :to,
      :country,
      :market,
      :custom

    attr_required :order_id

    def items=(arr)
      #raise ArgumentError.new('items= requires an Array') unless arr.is_a?(Array)

      @items = arr.map { |item| Ravelin::Item.new(item) }
    end

    def from=(obj)
      @from = Ravelin::Location.new(obj)
    end

    def to=(obj)
      @to = Ravelin::Location.new(obj)
    end
  end
end
