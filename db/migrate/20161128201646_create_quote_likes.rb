class CreateQuoteLikes < ActiveRecord::Migration
  def change
    create_table :quote_likes do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :quote, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
