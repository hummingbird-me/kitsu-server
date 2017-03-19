class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.references :user, index: true, foreign_key: true, null: false

      t.string :type, null: false
      t.jsonb :stats_data, null: false, default: {}

      t.timestamps null: false
    end
  end
end
