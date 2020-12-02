module Ravelin
  class App < RavelinObject
    attr_accessor :name, :platform, :domain

    PLATFORM_IOS = 'ios'
    PLATFORM_ANDROID = 'android'
    PLATFORM_WEB = 'web'
    PLATFORM_MOBILE_WEB = 'mobile-web'
    PLATFORM_VALUES = [PLATFORM_IOS, PLATFORM_ANDROID, PLATFORM_WEB, PLATFORM_MOBILE_WEB]

    def validate
      super

      raise ArgumentError, "Platform value be one of #{PLATFORM_VALUES.join(', ')}" unless App.valid_platform?(platform)
      raise ArgumentError, 'Domain is not valid' unless App.valid_domain?(domain)
    end

    def self.valid_platform?(platform)
      platform.nil? || PLATFORM_VALUES.include?(platform)
    end

    def self.valid_domain?(domain)
      domain.nil? || /^[a-z0-9\-\\.]+$/.match(domain)
    end

  end
end
