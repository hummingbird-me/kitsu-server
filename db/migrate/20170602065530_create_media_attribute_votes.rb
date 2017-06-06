class CreateMediaAttributeVotes < ActiveRecord::Migration
  def change
    create_table :media_attribute_votes do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.references :anime_media_attributes
      t.references :manga_media_attributes
      t.references :dramas_media_attributes
      t.references :media, polymorphic: true, required: true, null: false
      t.integer :vote, null: false, required: true
      t.index %i[user_id media_id media_type],
        name: 'index_user_media_on_media_attr_votes', unique: true
      t.timestamps null: false
    end
  end
end
