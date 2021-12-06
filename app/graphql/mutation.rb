# frozen_string_literal: true

class Mutation < ::Types::Objects::BaseObject
  field :change_favorites, mutation: ::Mutations::ChangeFavorites
  field :change_artist_status, mutation: ::Mutations::ChangeArtistStatus
  field :change_album_status, mutation: ::Mutations::ChangeAlbumStatus
  field :add_playlist_items, mutation: ::Mutations::AddPlaylistItems
end
