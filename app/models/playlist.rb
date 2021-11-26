# frozen_string_literal: true

class Playlist < ::ApplicationRecord
  def table_id() = 'pst'

  belongs_to :user
  belongs_to :track, optional: true
  has_many :playlist_items, dependent: :destroy
  has_many :favorites, as: :favorable, dependent: :destroy

  enum public_type: { non_open: 0, open: 1, anonymous_open: 2 }, _prefix: true

  validates :public_type, presence: true
  validates :name, presence: true, length: { maximum: 30 }

  class << self
    def generate_relation(conditions:, context:)
      cache = true
      conditions = { public_type: %i[open anonymous_open] }.merge(conditions)
      relation = ::Playlist.includes(:user).includes(:track)

      if conditions.delete(:is_mine)
        conditions = conditions.merge({ public_type: %i[open non_open anonymous_open] })
        relation = relation.where(user: context[:current_info][:user])
      end

      if conditions.key?(:name)
        name = conditions.delete(:name)
        relation = relation.where('playlists.name like :name', name: "%#{name}%")
      end

      { cache?: cache, relation: relation }
    end
  end
end
