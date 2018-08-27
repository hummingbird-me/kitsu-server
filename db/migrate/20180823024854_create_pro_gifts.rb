class CreateProGifts < ActiveRecord::Migration
  def change
    create_table :pro_gifts do |t|
      t.reference :from, null: false
      t.reference :to, null: false
      t.text :message

      t.timestamps null: false
    end
  end
end
