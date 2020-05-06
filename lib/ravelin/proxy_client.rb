module Ravelin
  class ProxyClient < Client
    def initialize(base_url:, username:, password:, api_version: 2)

      raise ArgumentError, "api_version must be 2 or 3" unless [2,3].include? api_version
      @api_version = api_version
      @url_prefix = '/ravelinproxy'

      @connection = Faraday.new(base_url, faraday_proxy_options) do |conn|
        conn.response :json, context_type: /\bjson$/
        conn.adapter Ravelin.faraday_adapter
        conn.basic_auth(username, password)
      end
    end

    def faraday_proxy_options
      {
        request: { timeout: Ravelin.faraday_timeout },
        headers: {
          'Content-Type'  => 'application/json; charset=utf-8'.freeze,
          'User-Agent'    => "Ravelin Proxy RubyGem/#{Ravelin::VERSION}".freeze
        }
      }
    end
  end
end
