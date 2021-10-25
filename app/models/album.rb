# frozen_string_literal: true

class Album < ::ApplicationRecord
  def table_id() = 'abm'

  has_many :artist_has_albums, dependent: :destroy
  has_many :artists, through: :artist_has_albums
  has_many :album_tracks, dependent: :destroy
  has_many :tracks, through: :album_tracks
  has_many :favorites, as: :favorable, dependent: :destroy

  enum status: { pending: 0, active: 1, ignore: 2 }

  class << self
    def create_by_service_id(service_id)
      album = find_by(service_id: service_id)
      return album if album

      create_by_service_id!(service_id)
    end

    def create_by_service_id!(service_id)
      attrs = hash_by_service_id(service_id)
      raise(::StandardError, 'hash_by_service_id が nil') unless attrs

      # @type var new_instance: ::Album
      new_instance = new(attrs)
      new_instance.save!
      new_instance
    end

    def hash_by_service_id(service_id)
      result = ::AppleMusic::Api.new.get_album(service_id)
      data = result['data'].first
      return unless data

      to_attributes(data)
    end

    def to_attributes(data)
      attrs = data['attributes']
      artwork = attrs['artwork']

      {
        service_id: data['id'],
        name: attrs['name'],
        playable: !attrs['playParams'].nil?,
        release_date: release_date_to_datetime(attrs['releaseDate']),
        total_tracks: attrs['trackCount'],
        record_label: attrs['recordLabel'],
        copyright: attrs['copyright'],
        artwork_url: artwork['url'],
        artwork_width: artwork['width'],
        artwork_height: artwork['height'],
        upc: attrs['upc']
      }
    end

    def release_date_to_datetime(release_date)
      date = release_date.dup.to_s
      date.gsub!(%r{/}, '-')

      case date
      when /\A[0-9]{4}\z/
        date << '-01-01'
      when /\A[0-9]{4}-[0-9]{1,2}\z/
        date << '-01'
      else
        date
      end.to_time
    end
  end
end
