class CreateLinkedSites < ActiveRecord::Migration
  def change
    create_table :linked_sites do |t|
      t.string :name, null: false
      t.boolean :share_to, null: false, default: false
      t.boolean :share_from, null: false, default: false
      t.integer :link_type, null: false

      t.timestamps null: false
    end
  end
end
