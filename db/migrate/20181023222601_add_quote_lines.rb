class AddQuoteLines < ActiveRecord::Migration[4.2]
  def change
    create_table :quote_lines do |t|
      t.references :quote, null: false, index: true
      t.references :character, null: false, index: true
      t.integer :order, null: false, index: true
      t.string :content, null: false
      t.timestamps null: false
    end
  end
end
