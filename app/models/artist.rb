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

  def artwork_l
    return ::Artwork.new unless (track = service_track)

    track.artwork_l
  end

  def artwork_m
    return ::Artwork.new unless (track = service_track)

    track.artwork_m
  end

  def service_track
    return unless (track = tracks.first)
    return unless (apple_music_track = track.apple_music_tracks.first)

    apple_music_track
  end
end
