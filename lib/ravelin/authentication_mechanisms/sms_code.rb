module Ravelin
  module AuthenticationMechanisms
    class SmsCode < RavelinObject
      FAILURE_REASONS = %w(INVALID_CODE CODE_TIMEOUT INTERNAL_ERROR RATE_LIMIT BANNED_USER AUTHENTICATION_FAILURE)

      attr_accessor :success, :phone_number, :failure_reason
      attr_required :success, :phone_number

      def failure_reason=(reason)
        @failure_reason = reason.to_s.upcase
      end

      def validate
        super

        if !success && !FAILURE_REASONS.include?(failure_reason)
          raise ArgumentError.new("Failure reason value must be one of #{FAILURE_REASONS.join(', ')}")
        end
      end
    end
  end
end
