module Ravelin
  class Login < RavelinObject
    attr_accessor :username,
      :customer_id,
      :success,
      :authentication_mechanism,
      :custom

    attr_required :username, :success, :authentication_mechanism

    def authentication_mechanism=(authm)
      @authentication_mechanism = Ravelin::AuthenticationMechanism.new(authm)
    end
  end
end
