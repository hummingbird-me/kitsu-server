class CreateMediaReactions < ActiveRecord::Migration
  def change
    create_table :media_reactions do |t|
      t.references :user, index: true, foreign_key: true, required: true
      t.references :media, null: false, polymorphic: true, required: true
      t.references :anime, index: true, foreign_key: true
      t.references :manga, index: true, foreign_key: true
      t.references :drama, index: true, foreign_key: true
      t.references :library_entry, index: true,
                                   foreign_key: true, required: true
      t.integer :up_votes_count, default: 0, null: false
      t.integer :progress, null: false, default: 0
      t.index %i[media_type media_id user_id], unique: true
      t.string :reaction, required: true, limit: 140
      t.timestamps null: false
    end
  end
end
