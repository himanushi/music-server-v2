# frozen_string_literal: true

require 'net/http'

module AppleMusic
  class Client
    ENDPOINT = 'https://api.music.apple.com'
    public_constant :ENDPOINT

    VERSION = 'v1'
    public_constant :VERSION

    LOCALE = 'jp'
    public_constant :LOCALE

    def initialize
      # @type var header: ::Hash[::String, untyped]
      header = {}
      header['authorization'] = "Bearer #{::AppleMusic::Token.create_server_token[:access_token]}"
      @header = header
    end

    def get(url, header = @header)
      uri = ::URI.parse(url)
      response = ::Net::HTTP.get_response(uri, header)
      ::JSON.parse(response.body)
    end
  end
end
