# frozen_string_literal: true

class AppleMusicTrack < ::ApplicationRecord
  def table_id() = 'amt'

  belongs_to :album
end
