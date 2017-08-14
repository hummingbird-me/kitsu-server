class CreateAmas < ActiveRecord::Migration
  def change
    create_table :amas do |t|
      t.string :description, null: false, required: true
      t.integer :author_id, index: true, null: false
      t.integer :original_post_id, index: true, null: false
      t.integer :ama_subscribers_count, null: false, default: 0
      t.datetime :start_date, null: false, required: true
      t.datetime :end_date, null: false, required: true
      t.timestamps null: false
    end
    add_foreign_key :amas, :users, column: :author_id
    add_foreign_key :amas, :posts, column: :original_post_id
  end
end
