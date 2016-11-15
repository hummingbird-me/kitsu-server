class CreateMediaFollows < ActiveRecord::Migration
  def change
    create_table :media_follows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :media, null: false, polymorphic: true
      t.timestamps null: false
    end
  end
end
