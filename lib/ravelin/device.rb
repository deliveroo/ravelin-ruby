module Ravelin
  class Device < RavelinObject
    attr_accessor :device_id,
      :type,
      :manufacturer,
      :model,
      :os,
      :ip_address,
      :browser,
      :javascript_enabled,
      :cookies_enabled,
      :screen_resolution
  end
end
