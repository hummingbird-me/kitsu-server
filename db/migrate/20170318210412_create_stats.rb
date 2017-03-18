class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.references :user, index: true, foreign_key: true, null: false

      t.string :type, null: false
      t.jsonb :data

      t.timestamps null: false
    end
  end
end
