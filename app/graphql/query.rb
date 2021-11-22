# frozen_string_literal: true

class Query < ::Types::Objects::BaseObject
  field :album,  resolver: ::Queries::AlbumQuery
  field :albums, resolver: ::Queries::AlbumsQuery
end
