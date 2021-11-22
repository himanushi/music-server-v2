# frozen_string_literal: true

module Queries
  class MeQuery < BaseQuery
    description 'カレントユーザー情報取得'

    type ::Types::Objects::CurrentUserObject, null: false

    def query
      context[:current_info][:user]
    end
  end
end
