class CreateMediaAttributes < ActiveRecord::Migration
  def change
    create_table :media_attributes do |t|
      t.string :title, null: false, index: true, required: true
      t.string :high_title, null: false, required: true
      t.string :neutral_title, null: false, required: true
      t.string :low_title, null: false, required: true
      t.string :slug, null: false, index: true
      t.timestamps null: false
    end
  end
end
