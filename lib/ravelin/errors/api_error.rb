module Ravelin
  class ApiError < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def to_s
      parts = [
        @response.status,
        @response.body.fetch('message', nil),
        @response.body.fetch('validationErrors', []).join('; ')
      ]

      parts.compact.join(' - ')
    end
  end
end
