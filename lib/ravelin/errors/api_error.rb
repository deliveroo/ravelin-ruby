module Ravelin
  class ApiError < StandardError
    attr_reader :response, :status, :error, :error_message, :validation_errors

    def initialize(response)
      @response           = response
      @status             = response.status
      @error              = response.body.fetch('Error', nil)
      @error_message      = response.body.fetch('message', nil)
      @validation_errors  = response.body.fetch('validationErrors', [])
    end

    def to_s
      parts = [self.status, self.error, self.error_message]
      parts << self.validation_errors.join('; ') if self.validation_errors.any?
      parts.compact.join(' - ')
    end
  end
end
