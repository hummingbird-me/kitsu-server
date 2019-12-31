class CreateMediaFollows < ActiveRecord::Migration[4.2]
  def change
    create_table :media_follows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :media, null: false, polymorphic: true
      t.timestamps null: false
    end
  end
end
