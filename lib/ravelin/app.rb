module Ravelin
  class App < RavelinObject
    attr_accessor :name, :platform, :domain

    PLATFORM_VALUES = %w(ios android web mobile-web)

    def validate
      super

      raise InvalidPlatformValueError.new("Platform value be one of #{PLATFORM_VALUES.join(', ')}") unless platform.nil? || PLATFORM_VALUES.include?(platform)
    end

  end
end
