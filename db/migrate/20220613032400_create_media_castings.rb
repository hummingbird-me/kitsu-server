class CreateMediaCastings < ActiveRecord::Migration[6.1]
  def change
    create_view :media_castings, materialized: true
    add_index :media_castings, :character_id
    add_index :media_castings, %i[media_type media_id]
    add_index :media_castings, :person_id
  end
end
