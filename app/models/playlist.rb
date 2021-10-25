# frozen_string_literal: true

class Playlist < ::ApplicationRecord
  def table_id() = 'pst'

  belongs_to :user
  belongs_to :track, optional: true
  has_many :playlist_items, dependent: :destroy
  has_many :favorites, as: :favorable, dependent: :destroy
end
