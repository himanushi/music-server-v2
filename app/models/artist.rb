# frozen_string_literal: true

class Artist < ::ApplicationRecord
  def table_id() = 'art'

  has_many :artist_has_albums, dependent: :destroy
  has_many :albums, through: :artist_has_albums
  has_many :artist_has_tracks, dependent: :destroy
  has_many :tracks, through: :artist_has_tracks
  has_many :apple_music_artists, dependent: :destroy
  has_many :favorites, as: :favorable, dependent: :destroy

  enum status: { pending: 0, active: 1, ignore: 2 }

  class << self
    def generate_relation(conditions:)
      # @type var album_ids: ::Array[::String]
      # @type var artist_ids: ::Array[::String]
      # @type var name: ::String

      cache = true
      conditions = { status: [:active] }.merge(conditions)
      relation = ::Artist.includes(albums: :apple_music_album)

      if conditions.key?(:name)
        name = conditions.delete(:name)
        relation = relation.where('artists.name like :name', name: "%#{name}%")
      end

      if conditions.key?(:album_ids)
        albums = ::Album.includes(:artists).includes(:tracks).where(id: conditions.delete(:album_ids))
        artist_ids = albums.map { |a| a.artists.ids }
                           .flatten
        artist_ids += albums.map { |a| a.tracks.includes(:artists).map { |t| t.artists.ids } }
                            .flatten
        relation = relation.where(id: artist_ids)
      end

      if conditions.key?(:track_ids)
        relation = relation.includes(:tracks).where(tracks: { id: conditions.delete(:track_ids) })
      end

      { cache?: cache, relation: relation }
    end
  end

  def artwork_l
    return ::Artwork.new unless (album = service_album)

    album.artwork_l
  end

  def artwork_m
    return ::Artwork.new unless (album = service_album)

    album.artwork_m
  end

  def service_album
    return unless (album = albums.first)
    return unless (apple_music_album = album.apple_music_album)

    apple_music_album
  end
end
