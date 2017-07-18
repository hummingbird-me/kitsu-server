class CreateMediaIgnores < ActiveRecord::Migration
  def change
    create_table :media_ignores do |t|
      t.references :media, index: true, polymorphic: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
