module Ravelin
  module AuthenticationMechanisms
    class MagicLink < RavelinObject
      TRANSPORTATION_MECHANISM = %w(email sms)
      FAILURE_REASONS = %w(INVALID_LINK TIMEOUT INTERNAL_ERROR RATE_LIMIT BANNED_USER)

      attr_accessor :transport, :success, :email, :phone_number, :failure_reason
      attr_required :transport, :success

      def failure_reason=(reason)
        @failure_reason = reason.to_s.upcase
      end

      def validate
        super

        if !success && !FAILURE_REASONS.include?(failure_reason)
          raise ArgumentError.new("Failure reason value must be one of #{FAILURE_REASONS.join(', ')}")
        end

        if !TRANSPORTATION_MECHANISM.include?(transport)
          raise ArgumentError.new("Transportation mechanism value must be one of #{TRANSPORTATION_MECHANISM.join(', ')}")
        end

        if transport == 'email' && email.nil?
          raise ArgumentError.new("email must be present for email transportation mechanism")
        end

        if transport == 'sms' && phone_number.nil?
          raise ArgumentError.new("phone_number must be present for sms transportation mechanism")
        end
      end
    end
  end
end
