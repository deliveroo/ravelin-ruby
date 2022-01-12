module Ravelin
  module AuthenticationMechanisms
    class MagicLink < RavelinObject
      DELIVERING_METHODS = %w(email sms)
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

        if !DELIVERING_METHODS.include?(transport)
          raise ArgumentError.new("Delivering method value must be one of #{DELIVERING_METHODS.join(', ')}")
        end
      end
    end
  end
end
