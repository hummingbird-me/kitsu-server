class AddWikiModels < ActiveRecord::Migration
  def change
    create_table :changesets do |t|
      t.references :user, null: false
      t.references :subject, polymorphic: true
      t.integer :status, null: false, default: 0
      t.jsonb :changes, null: false, default: {}
      t.text :notes
      t.timestamps null: false
    end

    create_table :changeset_moderator_actions do |t|
      t.references :moderator, null: false
      t.references :changeset, null: false
      t.integer :action, null: false
      t.timestamps null: false
    end
  end
end
