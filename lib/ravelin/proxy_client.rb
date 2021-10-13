module Ravelin
  class ProxyClient < Client
    def initialize(base_url:, username:, password:, api_version: 2, include_rule_output: false)

      raise ArgumentError, "api_version must be 2 or 3" unless [2,3].include? api_version
      @api_version = api_version
      @url_prefix = '/ravelinproxy'
      @include_rule_output = include_rule_output

      @connection = Faraday.new(base_url, faraday_proxy_options) do |conn|
        conn.response :json, context_type: /\bjson$/
        conn.adapter Ravelin.faraday_adapter
        conn.basic_auth(username, password)
      end
    end

    def faraday_proxy_options
      options = {
        request: { timeout: Ravelin.faraday_timeout },
        headers: {
          'Content-Type'  => 'application/json; charset=utf-8'.freeze,
          'User-Agent'    => "Ravelin Proxy RubyGem/#{Ravelin::VERSION}".freeze
        }
      }
      if @include_rule_output
        options[:headers]['Accept'] = 'application/vnd.ravelin.score.v2+json'
      end
      options
    end
  end
end
