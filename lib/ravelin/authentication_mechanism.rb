module Ravelin
  class AuthenticationMechanism < RavelinObject
    attr_accessor :password,
      :social,
      :one_time_code,
      :u2f,
      :rsa_key,
      :sms_code,
      :magic_link,
      :recaptcha

    def password=(passwd)
      @password = Ravelin::Password.new(passwd)
    end
  end
end
