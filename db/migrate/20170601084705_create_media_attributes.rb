class CreateMediaAttributes < ActiveRecord::Migration
  def change
    create_table :media_attribute do |t|
      t.string :title, null: false, index: true, required: true
      t.string :slug, null: false, index: true
      t.integer :high_vote_count, default: 0, null: false
      t.integer :neutral_vote_count, default: 0, null: false
      t.integer :low_vote_count, default: 0, null: false
      t.timestamps null: false
    end
  end
end
