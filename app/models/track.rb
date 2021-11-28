# frozen_string_literal: true

class Track < ::ApplicationRecord
  def table_id() = 'trk'

  has_many :artist_has_tracks, dependent: :destroy
  has_many :artists, through: :artist_has_tracks
  has_many :album_has_tracks, dependent: :destroy
  has_many :albums, through: :album_has_tracks
  has_many :apple_music_tracks, dependent: :destroy
  has_one :playlist
  has_many :playlist_items
  has_many :favorites, as: :favorable, dependent: :destroy

  enum status: { pending: 0, active: 1, ignore: 2 }

  delegate :apple_music_id, :apple_music_playable, :name, :artwork_m, :artwork_l, to: :service

  def service() = apple_music_tracks.first

  class << self
    def generate_relation(conditions:)
      cache = true
      conditions = { status: [:active] }.merge(conditions)
      relation = ::Track.includes(:apple_music_tracks)

      # ランダム取得
      if conditions.delete(:random)
        cache = false
        relation = relation.order('RAND()')
      end

      { cache?: cache, relation: relation }
    end
  end
end
