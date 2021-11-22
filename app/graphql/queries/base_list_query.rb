# frozen_string_literal: true

module Queries
  class BaseListQuery < ::Queries::BaseQuery
    def query(conditions:, sort:, cursor:)
      params = { conditions: conditions, sort: sort, cursor: cursor }
      cache_key = params.transform_values { |v| v.to_h }
                        .to_s

      result = list_query(conditions: conditions)

      cache = result[:cache?]
      relation = order(result[:relation], sort: sort, cursor: cursor)

      if cache && ::Rails.cache.exist?(cache_key)
        ::Rails.cache.read(cache_key)
      else
        loaded_result = relation.load
        ::Rails.cache.write(cache_key, loaded_result) if cache
        loaded_result
      end
    end

    def order(relation, sort:, cursor:)
      relation.order(
        [
          { sort[:order] => sort[:direction] },
          { id: sort[:direction] }
        ]
      ).distinct.offset(cursor[:offset]).limit(cursor[:limit])
    end
  end
end
