# frozen_string_literal: true

class CreateModels < ::ActiveRecord::Migration[6.1]
  def change
    create_table(:artists, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:name, limit: 191, null: false)
      t.integer(:status, null: false, default: 0)
      t.integer(:popularity, default: 0, null: false)
      t.integer(:pv, default: 0, null: false)
    end
    add_index(:artists, :name, unique: true)
    add_index(:artists, :status)
    add_index(:artists, :popularity)
    add_index(:artists, :created_at)

    create_table(:apple_music_artists, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:artist_id, limit: 16, null: false)
      t.string(:apple_music_id, limit: 191, null: false)
      t.string(:name, limit: 191, null: false)
    end
    add_foreign_key(:apple_music_artists, :artists, dependent: :destroy)
    add_index(:apple_music_artists, :name)
    add_index(:apple_music_artists, :apple_music_id, unique: true)

    create_table(:albums, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.integer(:status, null: false, default: 0)
      t.datetime(:release_date, null: false)
      t.string(:upc, limit: 191, null: false)
      t.integer(:total_tracks, null: false)
      t.integer(:popularity, default: 0, null: false)
      t.integer(:pv, default: 0, null: false)
    end
    add_index(:albums, :status)
    add_index(:albums, :release_date)
    add_index(:albums, :total_tracks)
    add_index(:albums, :popularity)
    add_index(:albums, :created_at)
    add_index(:albums, :upc, unique: true)

    create_table(:apple_music_albums, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:album_id, limit: 16, null: false)
      t.string(:apple_music_id, limit: 191, null: false)
      t.string(:name, limit: 191, null: false)
      t.boolean(:playable, default: false, null: false)
      t.datetime(:release_date, null: false)
      t.integer(:total_tracks, default: 0, null: false)
      t.text(:record_label, null: false)
      t.text(:copyright, null: false)
      t.text(:artwork_url, null: false)
      t.integer(:artwork_width, null: false)
      t.integer(:artwork_height, null: false)
      t.string(:upc, null: false)
      t.integer(:popularity, default: 0, null: false)
      t.integer(:pv, default: 0, null: false)
    end
    add_foreign_key(:apple_music_albums, :albums, dependent: :destroy)
    add_index(:apple_music_albums, :apple_music_id, unique: true)
    add_index(:apple_music_albums, :name)
    add_index(:apple_music_albums, :release_date)
    add_index(:apple_music_albums, :popularity)
    add_index(:apple_music_albums, :created_at)

    create_table(:artist_has_albums, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:artist_id, limit: 16, null: false)
      t.string(:album_id, limit: 16, null: false)
    end
    add_foreign_key(:artist_has_albums, :artists, dependent: :destroy)
    add_foreign_key(:artist_has_albums, :albums, dependent: :destroy)
    add_index(:artist_has_albums, %i[artist_id album_id], unique: true)

    create_table(:tracks, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.integer(:status, null: false, default: 0)
      t.string(:isrc, limit: 191, null: false)
      t.integer(:popularity, default: 0, null: false)
      t.integer(:pv, default: 0, null: false)
    end
    add_index(:tracks, :status)
    add_index(:tracks, :isrc, unique: true)
    add_index(:tracks, :popularity)
    add_index(:tracks, :created_at)

    create_table(:artist_has_tracks, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:artist_id, limit: 16, null: false)
      t.string(:track_id, limit: 16, null: false)
    end
    add_foreign_key(:artist_has_tracks, :artists, dependent: :destroy)
    add_foreign_key(:artist_has_tracks, :tracks, dependent: :destroy)
    add_index(:artist_has_tracks, %i[artist_id track_id], unique: true)

    create_table(:album_has_tracks, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:album_id, limit: 16, null: false)
      t.string(:track_id, limit: 16, null: false)
    end
    add_foreign_key(:album_has_tracks, :albums, dependent: :destroy)
    add_foreign_key(:album_has_tracks, :tracks, dependent: :destroy)
    add_index(:album_has_tracks, %i[album_id track_id], unique: true)

    create_table(:apple_music_tracks, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:apple_music_album_id, limit: 16, null: false)
      t.string(:track_id, limit: 16, null: false)
      t.string(:apple_music_id, limit: 191, null: false)
      t.string(:name, limit: 191, null: false)
      t.boolean(:playable, default: false, null: false)
      t.string(:isrc, limit: 191, null: false)
      t.integer(:disc_number, null: false, default: 0)
      t.integer(:track_number, null: false, default: 0)
      t.boolean(:has_lyrics, null: false, default: false)
      t.integer(:duration_ms, null: false, index: true)
      t.text(:preview_url, null: true)
      t.text(:artwork_url, null: false)
      t.integer(:artwork_width, null: false)
      t.integer(:artwork_height, null: false)
    end
    add_foreign_key(:apple_music_tracks, :apple_music_albums, dependent: :destroy)
    add_foreign_key(:apple_music_tracks, :tracks, dependent: :destroy)
    add_index(:apple_music_tracks, :name)
    add_index(:apple_music_tracks, :apple_music_id, unique: true)
    add_index(
      :apple_music_tracks,
      %i[apple_music_album_id disc_number track_number],
      unique: true,
      name: 'index_apple_music_tracks_on_am_id_and_numbers'
    )

    create_table(:ignore_contents, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:apple_music_id, limit: 191, null: false)
      t.string(:reason, limit: 191, null: false)
    end
    add_index(:ignore_contents, :apple_music_id, unique: true)

    create_table(:roles, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:name, limit: 191, null: false)
      t.string(:description, default: '', null: false)
    end
    add_index(:roles, :name, unique: true)

    create_table(:allowed_actions, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:role_id, limit: 16, null: false)
      t.string(:name, limit: 191, null: false)
    end
    add_foreign_key(:allowed_actions, :roles, dependent: :destroy)
    add_index(:allowed_actions, %i[role_id name], unique: true)

    create_table(:users, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:role_id, limit: 16, null: false)
      t.string(:name, limit: 191, null: false)
      t.string(:username, limit: 191, null: false)
      t.integer(:status, null: false, default: 0)
      t.boolean(:registered, default: false, null: false)
      t.string(:password_digest, limit: 191)
    end
    add_foreign_key(:users, :roles, dependent: :destroy)
    add_index(:users, :username, unique: true)

    create_table(:sessions, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:user_id, limit: 16, null: false)
      t.string(:token, limit: 191, null: false)
    end
    add_foreign_key(:sessions, :users, dependent: :destroy)

    create_table(:favorites, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:user_id, limit: 16, null: false)
      t.string(:favorable_id, limit: 16, null: false)
      t.string(:favorable_type, limit: 191, null: false)
    end
    add_foreign_key(:favorites, :users, dependent: :destroy)
    add_index(:favorites, %i[user_id favorable_id], unique: true)

    create_table(:playlists, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:track_id, limit: 16, null: true)
      t.string(:user_id, limit: 16, null: false)
      t.string(:name, limit: 191, null: false)
      t.text(:description)
      t.integer(:public_type, null: false)
      t.integer(:popularity, default: 0, null: false)
      t.integer(:pv, default: 0, null: false)
    end
    add_foreign_key(:playlists, :users, dependent: :destroy)
    add_index(:playlists, :name)
    add_index(:playlists, :popularity)
    add_index(:playlists, :created_at)
    add_index(:playlists, :updated_at)

    create_table(:playlist_items, id: false) do |t|
      t.string(:id, limit: 16, primary_key: true, null: false)
      t.timestamps
      t.string(:playlist_id, limit: 16, null: true)
      t.string(:track_id, limit: 16, null: false)
      t.integer(:track_number, null: false)
    end
    add_foreign_key(:playlist_items, :playlists, dependent: :destroy)
    add_foreign_key(:playlist_items, :tracks, dependent: :destroy)
    add_index(:playlist_items, %i[playlist_id track_number], unique: true)
  end
end
