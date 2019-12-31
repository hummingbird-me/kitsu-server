class CreateVolumes < ActiveRecord::Migration[4.2]
  def change
    create_table :volumes do |t|
      t.jsonb :titles, default: {}, null: false
      t.string :canonical_title
      t.integer :number, null: false
      t.attachment :thumbnail
      t.integer :chapters_count, null: false, default: 0
      t.references :manga, null: false
      t.string :isbn, null: false, array: true, default: []
      t.date :published_on
      t.timestamps null: false
    end
    add_column :chapters, :volume_id, :integer
  end
end
