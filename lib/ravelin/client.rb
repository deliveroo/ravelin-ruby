require 'faraday_middleware/response_middleware'

# This is a hack to compensate for Ravelin sending `null` in the response for 200's.
class FaradayMiddleware::ParseJson
  define_parser do |body|
    ::JSON.parse(body) unless body.strip.empty? || body.strip == 'null'
  end
end

module Ravelin
  class Client
    API_BASE = 'https://api.ravelin.com'

    def initialize(api_key:, api_version: 2, include_rule_output: false)
      @api_key = api_key
      @url_prefix = ''
      @include_rule_output = include_rule_output

      raise ArgumentError.new("api_version must be 2 or 3") unless [2,3].include? api_version
      @api_version = api_version

      @connection = Faraday.new(API_BASE, faraday_options) do |conn|
        conn.response :json, context_type: /\bjson$/
        conn.adapter Ravelin.faraday_adapter
      end
    end

    def send_event(**args)
      score = args.delete(:score)
      headers = args.delete(:headers)
      event = Event.new(**args)

      score_param = score ? "?score=true" : nil

      post("#{@url_prefix}/v#{@api_version}/#{event.name}#{score_param}", event.serializable_hash, headers)
    end

    def send_backfill_event(**args)
      unless args.has_key?(:timestamp)
        raise ArgumentError.new('missing parameters: timestamp')
      end

      event = Event.new(**args)

      post("#{@url_prefix}/v#{@api_version}/backfill/#{event.name}", event.serializable_hash)
    end

    def send_tag(**args)
      tag = Tag.new(**args)

      post("#{@url_prefix}/v#{@api_version}/tag/customer", tag.serializable_hash)
    end

    def delete_tag(**args)
      tag = Tag.new(**args).serializable_hash
      customer_id = tag["customerId"]
      tags = tag["tagNames"].join(",")

      delete("#{@url_prefix}/v#{@api_version}/tag/customer?customerId=#{customer_id}&tagName=#{tags}")
    end

    def get_tag(**args)
      tag = Tag.new(**args).serializable_hash
      customer_id = tag["customerId"]

      get("#{@url_prefix}/v#{@api_version}/tag/customer/#{customer_id}")
    end

    private

    def post(url, payload, headers = {})
      response = @connection.post(url, payload.to_json) do |request|
        headers&.each { |key, value|
          request.headers[key] = value
        }
      end

      if response.success?
        Response.new(response)
      else
        handle_error_response(response)
      end
    end

    def delete(url)
      response = @connection.delete(url)

      if response.success?
        Response.new(response)
      else
        handle_error_response(response)
      end
    end

    def get(url)
      response = @connection.get(url)

      if response.success?
        Response.new(response)
      else
        handle_error_response(response)
      end
    end

    def handle_error_response(response)
      case response.status
      when 400, 403, 404, 405, 406
        raise InvalidRequestError.new(response)
      when 401
        raise AuthenticationError.new(response)
      when 429
        raise RateLimitError.new(response)
      else
        raise ApiError.new(response)
      end
    end

    def faraday_options
      options = {
        request: { timeout: Ravelin.faraday_timeout },
        headers: {
          'Authorization' => "token #{@api_key}",
          'Content-Type'  => 'application/json; charset=utf-8'.freeze,
          'User-Agent'    => "Ravelin RubyGem/#{Ravelin::VERSION}".freeze
        }
      }

      if @include_rule_output
        options[:headers]['Accept'] = 'application/vnd.ravelin.score.v2+json'
      end

      options
    end
  end
end
