class CreateLeaderChatMessages < ActiveRecord::Migration
  def change
    create_table :leader_chat_messages do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :group, null: false, foreign_key: true, index: true
      t.text :content, null: false
      t.text :content_formatted, null: false
      t.timestamps null: false
      t.datetime :edited_at
    end
  end
end
