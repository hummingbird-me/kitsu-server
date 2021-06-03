class CreateWikiSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :wiki_submissions do |t|
      t.string :title
      t.text :notes
      t.integer :status, null: false, default: 0
      t.jsonb :data, null: false, default: {}

      t.references :user, index: true, foreign_key: true
      t.integer :parent_id, null: true, index: true

      t.timestamps
    end

    add_index :wiki_submissions, "(data->'id'),(data->'type')", name: "index_wiki_submission_on_data_id_and_data_type"
  end
end
