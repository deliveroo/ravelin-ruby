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

    def social=(mechanism)
      @social = Ravelin::AuthenticationMechanisms::Social.new(mechanism)
    end

    def sms_code=(mechanism)
      @sms_code = Ravelin::AuthenticationMechanisms::SmsCode.new(mechanism)
    end

    def magic_link=(mechanism)
      @magic_link = Ravelin::AuthenticationMechanisms::MagicLink.new(mechanism)
    end
  end
end
