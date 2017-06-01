class CreateMediaAttributes < ActiveRecord::Migration
  def change
    create_table :media_attribute do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.references :media, null: false, polymorphic: true
      t.integer :pacing, null: false
      t.integer :complexity, null: false
      t.integer :tone, null: false
      t.timestamps null: false     
    end
  end
end
