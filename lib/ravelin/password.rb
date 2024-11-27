require 'digest'

module Ravelin
  class Password < RavelinObject
    attr_accessor :success, :failure_reason, :password_hashed, :emailPasswordSHA256, :passwordSHA1SHA256
    attr_required :success

    # Alternative interface, because when the attr is called "password_hashed",
    # the end user might think they need to hash the password themselves
    def password=(passwd)
      @password_hashed = Digest::SHA256.hexdigest(passwd)
      @passwordSHA1SHA256 =  Digest::SHA256.hexdigest(Digest::SHA1.hexdigest(passwd))
    end

    def password_hashed=(passwd)
      @password_hashed = passwd
    end

    def emailPassword=(emailPassword)
      @emailPasswordSHA256 = Digest::SHA256.hexdigest(emailPassword)
    end

    def passwordSHA1SHA256=(passwd)
      @passwordSHA1SHA256 =  Digest::SHA256.hexdigest(Digest::SHA1.hexdigest(passwd))
    end 

    FAILURE_REASONS = %w(BAD_PASSWORD UNKNOWN_USERNAME AUTHENTICATION_FAILURE INTERNAL_ERROR RATE_LIMIT BANNED_USER)

    def validate
      super
      if !success && !FAILURE_REASONS.include?(failure_reason)
        raise ArgumentError.new("Failure reason value must be one of #{FAILURE_REASONS.join(', ')}")
      end
    end
  end
end
