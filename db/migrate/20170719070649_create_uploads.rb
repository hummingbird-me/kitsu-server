class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.references :owner, polymorphic: true, index: true
      t.references :user, foreign_key: true, index: true, null: false
      t.attachment :content, required: true
      t.timestamps null: false
    end
  end
end
