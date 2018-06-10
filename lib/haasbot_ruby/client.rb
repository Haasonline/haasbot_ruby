require 'faraday'
require 'json'
require 'uri'
require 'haasbot_ruby/api/market'

module HaasbotRuby
  class Client
    include HaasbotRuby::Api::Market

    def initialize(host, port)
      @host = host
      @port = port
    end

    private

    def get(path, query = {})
      uri = URI::HTTP.build(
        host: host,
        port: port,
        path: path,
        query: URI.encode_www_form(query),
        scheme: :http,
      )

      response = ::Faraday.get(uri.to_s)
      json = JSON.parse(response.body)

      if json['ErrorCode'] != 100
        error_class = RequestError.error_from_code(json['ErrorCode'])

        raise error_class.new(response)
      end
      json['Result']
    end

    attr_reader :host
    attr_reader :port
  end
end
