# frozen_string_literal: true

class Role < ::ApplicationRecord
  def table_id() = 'rol'

  has_many :users
  has_many :allowed_actions, dependent: :destroy
end
