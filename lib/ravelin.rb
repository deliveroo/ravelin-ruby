require 'date'
require 'json'
require 'faraday'
require 'faraday_middleware'

require 'ravelin/version'

require 'ravelin/errors/api_error'
require 'ravelin/errors/invalid_request_error'
require 'ravelin/errors/authentication_error'
require 'ravelin/errors/rate_limit_error'

require 'ravelin/ravelin_object'
require 'ravelin/chargeback'
require 'ravelin/customer'
require 'ravelin/device'
require 'ravelin/item'
require 'ravelin/location'
require 'ravelin/order'
require 'ravelin/payment_method'
require 'ravelin/transaction'

require 'ravelin/event'
require 'ravelin/response'
require 'ravelin/client'

module Ravelin
  @faraday_adapter = Faraday.default_adapter
  @faraday_timeout = 1

  class << self
    attr_accessor :faraday_adapter, :faraday_timeout

    def camelize(str)
      str.to_s.gsub(/_(.)/) { |e| $1.upcase }
    end
  end
end
