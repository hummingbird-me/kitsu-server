class CreateMediaAttributes < ActiveRecord::Migration
  def change
    create_table :media_attribute do |t|
      t.string :title, null: false, index: true, required: true
      t.string :slug, null: false, index: true
      t.timestamps null: false
    end
  end
end
