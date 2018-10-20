class UpdateQuotes < ActiveRecord::Migration
  def change
    # Add the character_id column
    add_column :quotes, :character_id, :integer

    # Delete all entries with incomplete dataset
    say_with_time 'Deleting quotes without Anime ID' do
      Quote.where(anime_id: nil).delete_all
    end
    # Move anime_id data over to media_id
    rename_column :quotes, :anime_id, :media_id
    change_column_null :quotes, :media_id, false

    # Content has to exist or else there is no quote
    # Character can't say nothing
    say_with_time 'Deleting quotes without content' do
      Quote.where(content: nil).delete_all
    end
    change_column_null :quotes, :content, false

    # Character needs to exist
    say_with_time 'Deleting quotes without a character name' do
      Quote.where(character_name: nil).delete_all
    end
    change_column_null :quotes, :character_name, false

    # Add type for polymorphic relationship
    add_column :quotes, :media_type, :string
    # Update all existing entries
    say_with_time 'Filling media_type column' do
      Quote.update_all(media_type: 'Anime')
    end
    change_column_null :quotes, :media_type, false

    # Rename our positive_votes to likes_count
    rename_column :quotes, :positive_votes, :likes_count

    # Add Indexes
    add_index :quotes, [:media_id, :media_type]
    add_index :quotes, :character_id
  end
end
