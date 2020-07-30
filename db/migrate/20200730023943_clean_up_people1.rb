class CleanUpPeople1 < ActiveRecord::Migration[5.1]
  def change
    remove_index :people, name: 'index_people_on_mal_id'
    remove_index :people, name: 'person_mal_id'
    remove_column :people, :mal_id
  end
end
