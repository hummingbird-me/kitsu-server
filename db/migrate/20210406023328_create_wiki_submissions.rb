class CreateWikiSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :wiki_submissions do |t|
      t.integer :status, null: false, default: 0
      t.jsonb :draft, null: false, default: {}

      t.references :user

      t.timestamps
    end
  end
end
