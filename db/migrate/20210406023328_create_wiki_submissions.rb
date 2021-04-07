class CreateWikiSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :wiki_submissions do |t|
      t.integer :type, null: false
      t.integer :status, null: false, default: 0
      t.integer :action, null: false
      t.jsonb :data, null: false, default: {}

      t.references :user

      t.timestamps
    end

    add_index :wiki_submissions, [:status, :type]
  end
end
