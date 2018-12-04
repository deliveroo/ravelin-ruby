module Ravelin
  class Response
    attr_reader :customer_id,
      :action,
      :client_reviewed_status,
      :score,
      :score_id,
      :source,
      :comment,
      :label,
      :tag_names,
      :tags,
      :http_status,
      :http_body

    def initialize(faraday_response)
      return if faraday_response.body.nil? || faraday_response.body.empty?
      response_body = faraday_response.body
      tag(response_body) if response_body.key?('tagNames')
      event(response_body) if response_body.key?('data')

      @http_status  = faraday_response.status
      @http_body    = faraday_response.body
    end

    private

    def event(response_body)
      data = response_body.fetch('data', {})

      @customer_id  = data['customerId']
      @action       = data['action']
      @score        = data['score']
      @score_id     = data['scoreId']
      @source       = data['source']
      @comment      = data['comment']
      @customer_id  = data['customerId']
    end

    def tag(response_body)
      @tag_names              = response_body['tagNames']
      @label                  = response_body['label'] if response_body.key?('label')
      @tags                   = response_body['tags'] if response_body.key?('tags')
      @client_reviewed_status = response_body['clientReviewedStatus'] if response_body.key?('clientReviewedStatus')
    end
  end
end
