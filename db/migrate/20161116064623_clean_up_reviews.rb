class CleanUpReviews < ActiveRecord::Migration
  class Vote < ActiveRecord::Base; end
  class Review < ActiveRecord::Base
    has_many :votes, as: 'target', dependent: :delete_all
  end

  def change
    #### Media Association
    # anime_id -> media_id
    rename_column :reviews, :anime_id, :media_id
    # Add media_type column
    add_column :reviews, :media_type, :string
    Review.update_all(media_type: 'Anime')
    change_column_null :reviews, :media_type, null: false
    # Remove nullability of media_id
    Review.where(media_id: nil).destroy_all
    change_column_null :reviews, :media_id, false

    #### User Association
    # Remove nullability of user
    Review.where(user_id: nil).destroy_all
    change_column_null :reviews, :user_id, false

    #### Ratings
    # Remove detailed ratings
    remove_column :reviews, :rating_story
    remove_column :reviews, :rating_animation
    remove_column :reviews, :rating_sound
    remove_column :reviews, :rating_character
    remove_column :reviews, :rating_enjoyment
    # Make rating non-nullable
    Review.where(rating: nil).destroy_all
    change_column_null :reviews, :rating, false

    #### Content Stuff
    # Add formatted content
    add_column :reviews, :content_formatted, :text
    # Copy formatted content
    execute 'UPDATE reviews SET content_formatted = content'
    # Remove nullability of content
    Review.where(content: nil).destroy_all
    change_column_null :reviews, :content, false
    change_column_null :reviews, :content_formatted, false
    # Add column to mark HTML-backed content
    add_column :reviews, :legacy, :boolean, default: false, null: false
    # Mark all reviews as legacy for now
    Review.update_all(legacy: true)

    #### Library Entry linkup
    # Add column
    add_column :reviews, :library_entry_id, :integer
    add_foreign_key :reviews, :library_entries
    # Fill column with existing data
    execute <<-SQL.squish
      UPDATE reviews r
      SET library_entry_id = (
        SELECT le.id
        FROM library_entries le
        WHERE le.media_type = r.media_type
        AND le.media_id = r.media_id
        AND le.user_id = r.user_id
      )
    SQL

    #### Review Likes
    # Create table
    create_table :review_likes do |t|
      t.timestamps null: false
      t.references :review, null: false
      t.references :user, null: false, foreign_key: true
    end
    # Move existing data
    execute <<-SQL.squish
      INSERT INTO review_likes (review_id, user_id, created_at, updated_at)
      SELECT target_id, user_id, created_at, updated_at
      FROM votes
      WHERE target_type = 'Review'
      AND positive = 't'
    SQL
    # Remove downvote stuff
    remove_column :reviews, :wilson_score
    remove_column :reviews, :total_votes
    # Rename our positive_votes to likes_count
    rename_column :reviews, :positive_votes, :likes_count
  end
end
