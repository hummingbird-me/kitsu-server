class CreateLinkedSites < ActiveRecord::Migration
  def change
    create_table :linked_sites do |t|
      t.string :name
      t.boolean :share_to
      t.boolean :share_from
      t.integer :link_type

      t.timestamps null: false
    end
  end
end
