class CreateProGifts < ActiveRecord::Migration
  def change
    create_table :pro_gifts do |t|
      t.references :from, null: false
      t.references :to, null: false
      t.text :message

      t.timestamps null: false
    end
  end
end
