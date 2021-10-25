# frozen_string_literal: true

class ServiceArtist < ::ApplicationRecord
  def table_id() = 'sar'

  belongs_to :artist
end
