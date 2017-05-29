class CreateMediaReactions < ActiveRecord::Migration
  def change
    create_table :media_reactions do |t|
      t.references :user, index: true, foreign_key: true, required: true
      t.references :media, null: false, polymorphic: true
      t.string :reaction, required: true, :limit => 140
      t.timestamps null: false
    end
  end
end
