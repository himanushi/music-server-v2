# frozen_string_literal: true

class Album < ::ApplicationRecord
  def table_id() = 'abm'

  has_many :artist_has_albums, dependent: :destroy
  has_many :artists, through: :artist_has_albums
  has_many :album_has_tracks, dependent: :destroy
  has_many :tracks, through: :album_has_tracks
  has_one :apple_music_album, dependent: :destroy
  has_many :favorites, as: :favorable, dependent: :destroy

  enum status: { pending: 0, active: 1, ignore: 2 }

  delegate :apple_music_id,
           :apple_music_playable,
           :name,
           :upc,
           :record_label,
           :copyright,
           :artwork_m,
           :artwork_l,
           to: :service

  def service() = apple_music_album

  class << self
    def generate_relation(conditions:)
      cache = true
      conditions = { status: [:active], **conditions }
      album_relation = ::Album.includes(:apple_music_album)

      # 名前あいまい検索
      if conditions.key?(:name)
        name = conditions.delete(:name)
        album_relation = album_relation.where('apple_music_albums.name like :name', name: "%#{name}%")
      end

      { cache?: cache, relation: album_relation }
    end
  end
end
