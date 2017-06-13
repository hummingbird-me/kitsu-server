class AddJoinTablesForMediaAttribute < ActiveRecord::Migration
  def change
    create_table :anime_media_attributes do |t|
      t.references :anime, null: false, index: true,
                           foreign_key: true, required: true
      t.references :media_attribute, null: false, index: true,
                                     foreign_key: true, required: true
      t.integer :high_vote_count, default: 0, null: false
      t.integer :neutral_vote_count, default: 0, null: false
      t.integer :low_vote_count, default: 0, null: false
      t.index %i[anime_id media_attribute_id],
        name: 'index_anime_media_attribute', unique: true
      t.timestamps null: false
    end
    create_table :dramas_media_attributes do |t|
      t.references :drama, null: false, index: true,
                           foreign_key: true, required: true
      t.references :media_attribute, null: false, index: true,
                                     foreign_key: true, required: true
      t.integer :high_vote_count, default: 0, null: false
      t.integer :neutral_vote_count, default: 0, null: false
      t.integer :low_vote_count, default: 0, null: false
      t.index %i[drama_id media_attribute_id],
        name: 'index_drama_media_attribute', unique: true
      t.timestamps null: false
    end
    create_table :manga_media_attributes do |t|
      t.references :manga, null: false, index: true,
                           foreign_key: true, required: true
      t.references :media_attribute, null: false, index: true,
                                     foreign_key: true, required: true
      t.integer :high_vote_count, default: 0, null: false
      t.integer :neutral_vote_count, default: 0, null: false
      t.integer :low_vote_count, default: 0, null: false
      t.index %i[manga_id media_attribute_id],
        name: 'index_manga_media_attribute', unique: true
      t.timestamps null: false
    end
  end
end
