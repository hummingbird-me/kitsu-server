class CreateNewCastTables < ActiveRecord::Migration[4.2]
  def change
    create_table :media_characters do |t|
      t.references :media, polymorphic: true, index: true, null: false
      t.references :character, index: true, null: false
      t.integer :role, default: 0, null: false
      t.timestamps null: false
    end

    create_table :character_voices do |t|
      t.references :media_character, index: true, null: false
      t.references :person, index: true, null: false
      t.string :locale, null: false
      t.references :licensor
      t.timestamps null: false
    end

    create_table :media_staff do |t|
      t.references :media, polymorphic: true, index: true, null: false
      t.references :person, index: true, null: false
      t.string :role
      t.timestamps null: false
    end

    create_table :media_productions do |t|
      t.references :media, polymorphic: true, index: true, null: false
      t.references :company, index: true, null: false
      t.integer :role, default: 0, null: false
      t.timestamps null: false
    end
  end
end
