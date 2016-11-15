class CreateLinkedProfiles < ActiveRecord::Migration
  def change
    create_table :linked_profiles do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :linked_site, index: true, foreign_key: true, null: false

      t.string :external_user_id, null: false
      t.string :url
      t.boolean :share_to, null: false, default: false
      t.boolean :share_from, null: false, default: false
      t.boolean :public, null: false, default: false
      t.string :token

      t.timestamps null: false
    end
  end
end
