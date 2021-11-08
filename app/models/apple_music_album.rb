# frozen_string_literal: true

class AppleMusicAlbum < ::ApplicationRecord
  def table_id() = 'amb'

  belongs_to :album
end
