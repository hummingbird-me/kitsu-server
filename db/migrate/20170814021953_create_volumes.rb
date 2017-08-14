class CreateVolumes < ActiveRecord::Migration
  def change
    create_table :volumes do |t|
      t.string :title, required: true, null: false
      t.string :isbn, required: true, null: false
      t.references :manga, foreign_key: true, index: true, null: false, required: true
      t.timestamps null: false
    end
  end
end
