# frozen_string_literal: true

class Album < ::ApplicationRecord
  def table_id() = 'abm'

  has_many :artist_has_albums, dependent: :destroy
  has_many :artists, through: :artist_has_albums
  has_many :album_has_tracks, dependent: :destroy
  has_many :tracks, through: :album_has_tracks
  has_many :favorites, as: :favorable, dependent: :destroy

  enum status: { pending: 0, active: 1, ignore: 2 }
end
