# frozen_string_literal: true

module Mutations
  class ChangeFavorites < ::Mutations::BaseMutation
    description 'お気に入り一括変更'

    argument :artist_ids, [::String], required: false, description: 'お気に入り変更したいアーティストID'
    argument :album_ids, [::String], required: false, description: 'お気に入り変更したいアルバムID'
    argument :track_ids, [::String], required: false, description: 'お気に入り変更したいトラックID'
    argument :playlist_ids, [::String], required: false, description: 'お気に入り変更したいプレイリストID'
    argument :radio_ids, [::String], required: false, description: 'お気に入り変更したいラジオID'
    argument :favorite,
             ::GraphQL::Types::Boolean,
             required: true,
             description: 'true の場合は一括でお気に入り登録をする。false 場合は一括で解除する。'

    field :current_user, ::Types::Objects::CurrentUserObject, null: true, description: '更新されたカレントユーザー'

    def mutate(favorite:, artist_ids: [], album_ids: [], track_ids: [], playlist_ids: [])
      artists = ::Artist.where(id: artist_ids)
      albums  = ::Album.where(id: album_ids)
      tracks  = ::Track.where(id: track_ids)
      playlists = ::Playlist.where(id: playlist_ids)

      # if favorite
      #   ::Favorite.register(artists + albums + tracks + playlists, context[:current_info][:user])
      # else
      #   ::Favorite.unregister(artists + albums + tracks + playlists, context[:current_info][:user])
      # end

      {
        current_user: context[:current_info][:user].reload
      }
    end
  end
end
