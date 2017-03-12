class AddMemberAndBanNotes < ActiveRecord::Migration
  def change
    # Add GroupBan#notes column
    add_column :group_bans, :notes, :text
    add_column :group_bans, :notes_formatted, :text

    # Add GroupMemberNote table
    create_table :group_member_notes do |t|
      t.references :group_member, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.text :content_formatted, null: false
      t.timestamps null: false
    end
  end
end
