module Ravelin
  class AtoLogin < RavelinObject
    attr_accessor :login,
      :device,
      :location

    attr_required :login

    def login=(l)
      @login = Ravelin::Login.new(l)
    end
  end
end
