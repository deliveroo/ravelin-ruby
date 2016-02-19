module Ravelin
  class Response
    attr_reader :customer_id,
      :action,
      :score,
      :score_id,
      :source,
      :comment,
      :http_status,
      :http_body

    def initialize(faraday_response)
      data = faraday_response.body.fetch('data', {})

      @customer_id  = data['customerId']
      @action       = data['action']
      @score        = data['score']
      @score_id     = data['scoreId']
      @source       = data['source']
      @comment      = data['comment']
      @customer_id  = data['customerId']
      @http_status  = faraday_response.status
      @http_body    = faraday_response.body
    end
  end
end
