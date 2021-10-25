# frozen_string_literal: true

class AllowedAction < ::ApplicationRecord
  def table_id() = 'ald'

  belongs_to :role
end
