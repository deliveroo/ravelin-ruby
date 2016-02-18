require 'json'
require 'faraday'
require 'faraday_middleware'

require 'ravelin/version'

require 'ravelin/errors/invalid_parameters_error'
require 'ravelin/errors/api_error'
require 'ravelin/errors/invalid_request_error'
require 'ravelin/errors/authentication_error'
require 'ravelin/errors/rate_limit_error'

require 'ravelin/ravelin_object'
require 'ravelin/customer'
require 'ravelin/event'
require 'ravelin/client'

module Ravelin
  @faraday_adapter = Faraday.default_adapter

  class << self
    attr_accessor :faraday_adapter
  end
end
