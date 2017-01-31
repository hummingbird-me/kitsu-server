class CreateNewCastingTables < ActiveRecord::Migration
  def change
    # Characters (an association between Media <-> Character)
    create_table :anime_characters do |t|
      t.references :anime, foreign_key: true, index: true, null: false
      t.references :character, foreign_key: true, index: true, null: false
      t.integer :role, default: 1, null: false
      t.index %i[anime_id character_id], unique: true
    end
    create_table :manga_characters do |t|
      t.references :manga, foreign_key: true, index: true, null: false
      t.references :character, foreign_key: true, index: true, null: false
      t.integer :role, default: 1, null: false
      t.index %i[manga_id character_id], unique: true
    end
    create_table :drama_characters do |t|
      t.references :drama, foreign_key: true, index: true, null: false
      t.references :character, foreign_key: true, index: true, null: false
      t.integer :role, default: 1, null: false
      t.index %i[drama_id character_id], unique: true
    end

    # Castings (MediaCharacter <-> Person, usually the VA)
    create_table :anime_castings do |t|
      t.references :anime_character, foreign_key: true, index: true, null: false
      t.references :person, foreign_key: true, index: true, null: false
      t.string :locale, null: false
      t.references :licensor
      t.foreign_key :producers, column: 'licensor_id'
      t.string :notes
      t.index %i[anime_character_id person_id locale], unique: true,
        name: 'index_anime_castings_on_character_person_locale'
    end
    create_table :drama_castings do |t|
      t.references :drama_character, foreign_key: true, index: true, null: false
      t.references :person, foreign_key: true, index: true, null: false
      t.string :locale, null: false
      t.references :licensor
      t.foreign_key :producers, column: 'licensor_id'
      t.string :notes
      t.index %i[drama_character_id person_id locale], unique: true,
        name: 'index_drama_castings_on_character_person_locale'
    end

    # Staff
    create_table :anime_staff do |t|
      t.references :anime, foreign_key: true, index: true, null: false
      t.references :person, foreign_key: true, index: true, null: false
      t.string :role
      t.index %i[anime_id person_id], unique: true
    end
    create_table :manga_staff do |t|
      t.references :manga, foreign_key: true, index: true, null: false
      t.references :person, foreign_key: true, index: true, null: false
      t.string :role
      t.index %i[manga_id person_id], unique: true
    end
    create_table :drama_staff do |t|
      t.references :drama, foreign_key: true, index: true, null: false
      t.references :person, foreign_key: true, index: true, null: false
      t.string :role
      t.index %i[drama_id person_id], unique: true
    end
  end
end
