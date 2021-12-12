# frozen_string_literal: true

module AppleMusic
  class Artist
    class << self
      def create_full(apple_music_id, force: false)
        am = ::AppleMusicArtist.find_by(apple_music_id: apple_music_id)
        return am.artist unless !am || force

        artists_data = ::AppleMusic::Api.new.get_artist(apple_music_id)
        raise(::StandardError, 'アーティストがいない！') unless (artist_data = artists_data['data'].first)

        artist = ::Artist.find_or_initialize_by(name: ::Convert.to_name(artist_data['attributes']['name']))
        ama = ::AppleMusicArtist.find_or_initialize_by(apple_music_id: artist_data['id'])
        ama.artist = artist
        ama.name = artist_data['attributes']['name']
        ama.save!

        ama.artist
      end
    end
  end
end
