module Ravelin
  class Login < RavelinObject
    attr_accessor :username,
      :customer_id,
      :success,
      :authentication_mechanism

    def authentication_mechanism=(authm)
      @authentication_mechanism = Ravelin::AuthenticationMechanism.new(authm)
    end

    attr_required :username, :customer_id, :success, :authentication_mechanism
  end
end
