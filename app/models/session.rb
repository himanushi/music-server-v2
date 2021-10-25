# frozen_string_literal: true

class Session < ::ApplicationRecord
  def table_id() = 'ses'

  belongs_to :user
end
