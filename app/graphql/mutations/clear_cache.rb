# frozen_string_literal: true

module Mutations
  class ClearCache < ::Mutations::BaseMutation
    description '検索結果キャッシュをリセットする'

    field :results, [::String], null: true

    def mutate
      size = ::File::Stat.new(::Rails.root.join('tmp', 'cache')).size.to_s

      {
        results: [size, *::Rails.cache.clear]
      }
    end
  end
end
