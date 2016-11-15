class CreateBestowmentCashes < ActiveRecord::Migration
  def change
    create_table :bestowment_cashes do |t|
      t.string :badge_id, null: false
      t.integer :rank
      t.integer :number, default: 0, null: false

      t.timestamps null: false
    end
  end
end
