# frozen_string_literal: true

class AppleMusicAlbum < ::ApplicationRecord
  def table_id() = 'amb'

  belongs_to :album
  has_many :apple_music_tracks, dependent: :destroy

  class << self
    def create_by_data(data)
      raise(::StandardError, 'album data が存在しない') unless (album = data['data'].first)

      if (am_album = find_by(upc: album['attributes']['upc']))
        am_album.destroy!
      end

      instance = new(mapping(album).merge(mapping_relation(album)))
      instance.save!
      instance
    end

    def mapping(data)
      attrs = data['attributes']
      artwork = attrs['artwork']

      {
        apple_music_id: data['id'],
        name: attrs['name'],
        playable: attrs['playParams'].present?,
        upc: attrs['upc'].upcase,
        release_date: attrs['releaseDate'],
        total_tracks: attrs['trackCount'],
        record_label: attrs['recordLabel'],
        copyright: attrs['copyright'],
        artwork_url: artwork['url'],
        artwork_width: artwork['width'],
        artwork_height: artwork['height']
      }
    end

    def mapping_relation(data)
      tracks_data = data['relationships']['tracks']['data']

      apple_music_tracks =
        tracks_data.map do |track_data|
          ::AppleMusicTrack.create_by_data(track_data)
        end

      {
        album: ::Album.find_by!(upc: data['attributes']['upc']),
        apple_music_tracks: apple_music_tracks.compact
      }
    end
  end
end
