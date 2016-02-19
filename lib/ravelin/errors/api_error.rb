module Ravelin
  class ApiError < StandardError
    attr_reader :response, :status, :message, :validation_errors

    def initialize(response)
      @response           = response
      @status             = response.status
      @message            = response.body.fetch('message', nil)
      @validation_errors  = response.body.fetch('validationErrors', [])
    end

    def to_s
      parts = [self.status, self.message]
      parts << self.validation_errors.join('; ') if self.validation_errors.any?
      parts.compact.join(' - ')
    end
  end
end
