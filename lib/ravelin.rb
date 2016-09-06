require 'date'
require 'json'
require 'faraday'
require 'faraday_middleware'

require 'ravelin/version'

require 'ravelin/errors/api_error'
require 'ravelin/errors/invalid_request_error'
require 'ravelin/errors/authentication_error'
require 'ravelin/errors/rate_limit_error'
require 'ravelin/errors/invalid_label_value_error'

require 'ravelin/ravelin_object'
require 'ravelin/chargeback'
require 'ravelin/customer'
require 'ravelin/device'
require 'ravelin/item'
require 'ravelin/location'
require 'ravelin/order'
require 'ravelin/payment_method'
require 'ravelin/pre_transaction'
require 'ravelin/transaction'
require 'ravelin/voucher'
require 'ravelin/voucher_redemption'
require 'ravelin/label'

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

    def datetime_to_epoch(val)
      case val
      when Date
        val.to_datetime.to_time.to_i
      when DateTime
        val.to_time.to_i
      when Time
        val.to_i
      else
        val.to_i
      end
    end

    def convert_ids_to_strings(key, value)
      key.to_s.match(/_id\Z/) && value.is_a?(Integer) ? value.to_s : value
    end
  end
end
