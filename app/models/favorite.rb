# frozen_string_literal: true

class Favorite < ::ApplicationRecord
  def table_id() = 'fav'

  belongs_to :favorable, polymorphic: true
  belongs_to :user
end
