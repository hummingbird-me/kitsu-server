class CreateBestowments < ActiveRecord::Migration
  def change
    create_table :bestowments do |t|
      t.string :badge_id, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :progress, null: false, default: 0
      t.integer :rank, default: 0
      t.datetime :bestowed_at

      t.timestamps null: false
    end
  end
end
