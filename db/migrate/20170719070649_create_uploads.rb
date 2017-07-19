class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.references :post, foreign_key: true, index: true
      t.references :comment, foreign_key: true, index: true
      t.attachment :content, required: true
      t.timestamps null: false
    end
  end
end
