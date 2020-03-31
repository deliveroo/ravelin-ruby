module Ravelin
  class AtoReclaim < RavelinObject
    attr_accessor :customers,
                  :source

    attr_required :customers, :source
  end
end
