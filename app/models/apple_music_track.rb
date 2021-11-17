# frozen_string_literal: true

class AppleMusicTrack < ::ApplicationRecord
  def table_id() = 'amt'

  belongs_to :apple_music_album
  belongs_to :track

  class << self
    def create_by_data(data)
      new(mapping(data).merge(mapping_relation(data)))
    end

    def mapping(data)
      attrs = data['attributes']

      if (preview = attrs['previews'].first)
        url = preview['url']
      end

      artwork = attrs['artwork']

      {
        apple_music_id: data['id'],
        name: attrs['name'],
        playable: attrs['playParams'].present?,
        isrc: attrs['isrc'].upcase,
        disc_number: attrs['discNumber'],
        track_number: attrs['trackNumber'],
        has_lyrics: attrs['hasLyrics'],
        duration_ms: attrs['durationInMillis'],
        preview_url: url,
        artwork_url: artwork['url'],
        artwork_width: artwork['width'],
        artwork_height: artwork['height']
      }
    end

    def mapping_relation(data)
      attrs = data['attributes']
      isrc = attrs['isrc'].upcase
      track = ::Track.find_by!(isrc: isrc)

      {
        track: track
      }
    end
  end
end
