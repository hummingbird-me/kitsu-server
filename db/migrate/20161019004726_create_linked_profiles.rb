class CreateLinkedProfiles < ActiveRecord::Migration
  def change
    create_table :linked_profiles do |t|
      t.references :user, index: true, foreign_key: true
      t.references :linked_site, index: true, foreign_key: true

      t.integer :external_user_id
      t.string :url
      t.boolean :share_to
      t.boolean :share_from
      t.string :token

      t.timestamps null: false
    end
  end
end
