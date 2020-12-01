module Ravelin
  class App < RavelinObject
    attr_accessor :name, :platform, :domain

    PLATFORM_VALUES = %w(ios android web mobile-web)

    def validate
      super

      raise ArgumentError, "Platform value be one of #{PLATFORM_VALUES.join(', ')}" unless platform.nil? || PLATFORM_VALUES.include?(platform)
      raise ArgumentError, 'Domain does not match regex  ^[a-z0-9-\\.]+$' unless domain.nil? ||  /^[a-z0-9-\\.]+$/.match(domain)
    end

  end
end
