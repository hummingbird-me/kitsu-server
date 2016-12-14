class UpdateQuotes < ActiveRecord::Migration
  def change
    # Delete all entries with incomplete dataset
    Quote.where(anime_id: nil).destroy_all
    # Merge anime_id data over to media_id
    rename_column :quotes, :anime_id, :media_id
    change_column_null :quotes, :media_id, false

    # Content has to exist or else there is no quote
    # Character can't say nothing
    Quote.where(content: nil).destroy_all
    change_column_null :quotes, :content, false

    # Character needs to exist?
    Quote.where(character_name: nil).destroy_all
    change_column_null :quotes, :character_name, false

    # Add type for polymorphic relationship
    add_column :quotes, :media_type, :string
    # Update all existing entries
    Quote.update_all(media_type: 'Anime')
    change_column_null :quotes, :media_type, false

    # Add reference to characters table
    add_reference :quotes, :character, foreign_key: true
    change_column_null :quotes, :character_id, false

    # Rename our positive_votes to likes_count
    rename_column :quotes, :positive_votes, :likes_count

    # Add Indexes
    add_index :quotes, [:media_id, :media_type]
    add_index :quotes, :character_id
  end
end
