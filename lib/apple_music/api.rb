# frozen_string_literal: true

module AppleMusic
  class Api
    ENDPOINT = 'https://api.music.apple.com'
    public_constant :ENDPOINT

    RSS_ENDPOINT = 'https://rss.applemarketingtools.com/api/v2'
    public_constant :RSS_ENDPOINT

    LOCALE = 'jp'
    public_constant :LOCALE

    DEFAULT_REPEAT = 5
    public_constant :DEFAULT_REPEAT

    class << self
      def apple_music_most_played
        ::AppleMusic::Client.new.get(
          "#{::AppleMusic::Api::RSS_ENDPOINT}/#{::AppleMusic::Api::LOCALE}/music/most-played/50/albums.json", {}, {}
        )
      end
    end

    def initialize
      @client = ::AppleMusic::Client.new
      @locale = ::AppleMusic::Api::LOCALE
      @repeat = ::AppleMusic::Api::DEFAULT_REPEAT
    end

    def get(url, params = nil)
      return {} unless @repeat.positive?

      @repeat -= 1

      # @type var body: ::Hash[::String, untyped]
      body = @client.get(::AppleMusic::Api::ENDPOINT + url, params || {})
      compound(body)
    end

    def index(url, params = nil)
      return {} unless @repeat.positive?

      @repeat -= 1

      # @type var body: ::Hash[::String, untyped]
      body = @client.get(::AppleMusic::Api::ENDPOINT + url, params || {})
      compound_index(body)
    end

    def index_artists_by_name(name, repeat = nil)
      @repeat = repeat if repeat
      # @type var params: ::Hash[::String, untyped]
      params = {}
      params['term']  = name
      params['types'] = 'artists'
      params['limit'] = '20'
      index("#{catalog_url}/search", params)
    end

    def get_artist(apple_music_id)
      get("#{catalog_url}/artists/#{apple_music_id}")
    rescue ::StandardError
      # アーティストを参照できない場合がある
      {}
    end

    def get_artist_albums(apple_music_id, repeat = nil)
      @repeat = repeat if repeat
      get("#{catalog_url}/artists/#{apple_music_id}/albums")
    rescue ::StandardError
      # アーティストを参照できない場合がある
      {}
    end

    def get_artist_tracks(apple_music_id, repeat = nil)
      @repeat = repeat if repeat
      get("#{catalog_url}/artists/#{apple_music_id}/songs")
    rescue ::StandardError
      # アーティストを参照できない場合がある
      {}
    end

    def get_album(apple_music_id)
      get("#{catalog_url}/albums/#{apple_music_id}")
    end

    def get_track_by_isrc(isrc)
      # @type var params: ::Hash[::String, untyped]
      params = {}
      params['filter[isrc]'] = isrc
      get("#{catalog_url}/songs", params)
    end

    private

    def compound(body)
      if body['next']
        data = body['data']
        next_data = get(body['next'])['data'] || []
        # @type var result: ::Hash[::String, untyped]
        result = {}
        result['data'] = data + next_data
        result
      else
        body
      end
    end

    def compound_index(body)
      if body['results']['artists']['next']
        data = body['results']['artists']['data']
        next_data = index(body['results']['artists']['next'])['data'] || []
        # @type var result: ::Hash[::String, untyped]
        result = {}
        result['data'] = data + next_data
        result
      else
        body['results']['artists']
      end
    end

    def catalog_url
      "/v1/catalog/#{@locale}"
    end
  end
end
