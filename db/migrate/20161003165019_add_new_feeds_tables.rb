class AddNewFeedsTables < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true, null: false
      t.references :target
      t.foreign_key :users, column: :target_id
      t.text :text, null: false
      t.text :text_formatted, null: false
      t.references :media, polymorphic: true
      t.boolean :spoiler, null: false, default: false
      t.boolean :nsfw, null: false, default: false
      t.boolean :blocked, null: false, default: false
      t.references :spoiled_unit, polymorphic: true
      t.timestamps null: false
    end
    create_table :comments do |t|
      t.references :post, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.text :text, null: false
      t.text :text_formatted, null: false
      t.timestamps null: false
    end
    create_table :post_likes do |t|
      t.references :post, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps null: false
    end
  end
end
