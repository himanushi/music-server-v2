# frozen_string_literal: true

class AlbumTrack < ::ApplicationRecord
  def table_id() = 'abt'

  belongs_to :album
  belongs_to :track
end
