module Ravelin
  class Order < RavelinObject
    attr_accessor :order_id,
      :email,
      :price,
      :currency,
      :seller_id,
      :from,
      :to,
      :country,
      :market,
      :custom

    attr_required :order_id, :price

    def from=(obj)
      @from = Ravelin::Location.new(obj)
    end

    def to=(obj)
      @to = Ravelin::Location.new(obj)
    end
  end
end
