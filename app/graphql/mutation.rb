# frozen_string_literal: true

class Mutation < ::Types::Objects::BaseObject
  field :change_favorites, mutation: ::Mutations::ChangeFavorites
  field :change_artist_status, mutation: ::Mutations::ChangeArtistStatus
  field :change_album_status, mutation: ::Mutations::ChangeAlbumStatus
  field :force_ignore_album, mutation: ::Mutations::ForceIgnoreAlbum
  field :add_playlist_items, mutation: ::Mutations::AddPlaylistItems
  field :delete_playlist, mutation: ::Mutations::DeletePlaylist
  field :clear_cache, mutation: ::Mutations::ClearCache
end
