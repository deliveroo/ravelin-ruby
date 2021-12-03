module Ravelin
  module AuthenticationMechanisms
    class Social < RavelinObject
      PROVIDERS = %w(apple azure facebook google linkedin microsoft okta onelogin ping twitter)
      FAILURE_REASONS = %w(TIMEOUT UNKNOWN_USERNAME INTERNAL_ERROR RATE_LIMIT SOCIAL_FAILURE BANNED_USER)

      attr_accessor :success, :social_provider, :failure_reason
      attr_required :success, :social_provider

      def social_provider=(provider)
        @social_provider = provider.to_s.downcase
      end

      def failure_reason=(reason)
        @failure_reason = reason.to_s.upcase
      end

      def validate
        super

        if !success && !FAILURE_REASONS.include?(failure_reason)
          raise ArgumentError.new("Failure reason value must be one of #{FAILURE_REASONS.join(', ')}")
        end

        if !PROVIDERS.include?(social_provider)
          raise ArgumentError.new("Social provider value must be one of #{PROVIDERS.join(', ')}")
        end
      end
    end
  end
end
