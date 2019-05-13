module Ravelin
  class AtoLogin < RavelinObject
    attr_accessor :login,
      :device,
      :location

    def login=(l)
      @login = Ravelin::Login.new(l)
    end

    attr_required :login
  end
end
