# frozen_string_literal: true

module Queries
  class AlbumQuery < ::Queries::BaseQuery
    description 'アルバム情報取得'

    type ::Types::Objects::AlbumType, null: true

    argument :id, ::String, required: true, description: 'ID'

    def query(**params)
      ::Album.find_by(id: params[:id])
    end
  end
end
