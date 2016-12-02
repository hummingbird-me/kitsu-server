class UpdateQuotes < ActiveRecord::Migration
  def change
    # Delete all entries with incomplete dataset
    Quote.where(anime_id: nil).destroy_all

    # Merge anime_id data over to media_id
    rename_column :quotes, :anime_id, :media_id

    # Add type for polymorphic relationship
    add_column :quotes, :media_type, :string,
    change_column_null :quotes, :media_type, false, default: 'Anime'

    # Update all existing entries
    Quote.update_all(media_type: 'Anime')

    # Delete all entries with incomplete dataset
    Quote.where(user_id: nil).destroy_all

    # Makes sure no more invalid data can be added
    change_column_null :quotes, :user_id, false

    # Add reference to characters table
    add_reference :quotes, :character, foreign_key: true

    # Rename our positive_votes to likes_count
    rename_column :quotes, :positive_votes, :likes_count

    # Add Indexes
    add_index :quotes, [:media_id, :media_type]
    add_index :quotes, :character_id
  end
end
