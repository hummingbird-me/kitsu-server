class CreateMediaAttributeVotes < ActiveRecord::Migration
  def change
    create_table :media_attribute_votes do |t|
      t.references :user, foreign_key: true, index: true, null: false
      ActiveRecord::Base.pluralize_table_names = false
      t.references :media_attribute, null: false, index: true
      ActiveRecord::Base.pluralize_table_names = true
      t.references :media, polymorphic: true, required: true, null: false
      t.integer :vote, null: false, required: true
      t.index %i[user_id media_id media_type media_attribute_id],
        name: 'index_user_media_attribute', unique: true
      t.timestamps null: false
    end
  end
end
