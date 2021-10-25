# frozen_string_literal: true

class User < ::ApplicationRecord
  def table_id() = 'usr'

  belongs_to :role
  has_many :sessions, dependent: :destroy
end
