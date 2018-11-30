module Ravelin
  class Response
    attr_reader :customer_id,
      :action,
      :score,
      :score_id,
      :source,
      :comment,
      :label,
      :tag_names,
      :http_status,
      :http_body

    def initialize(faraday_response)
      return if faraday_response.body.nil? || faraday_response.body.empty?

      data = faraday_response.body.fetch('data', {})

      tag(data) if data.key?('tagNames')
      event(data) if data.key?('action')

      @http_status  = faraday_response.status
      @http_body    = faraday_response.body
    end

    private

    def event(data)
      @customer_id  = data['customerId']
      @action       = data['action']
      @score        = data['score']
      @score_id     = data['scoreId']
      @source       = data['source']
      @comment      = data['comment']
      @customer_id  = data['customerId']
    end

    def tag(data)
      @tag_names    = data['tagNames']
      @label        = data['label']
    end
  end
end
