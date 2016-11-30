class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      # To be filled out by reporter only
      t.references :naughty, null: false, polymorphic: true, index: true
      t.integer :reason, null: false
      t.text :explanation
      # To be filled out automatically
      t.references :user, null: false, foreign_key: true
      t.timestamps null: false
      # To be filled out by office only
      t.integer :status, null: false, default: 0, index: true
      t.references :moderator
      t.foreign_key :users, column: 'moderator_id'
      # Indices
      t.index [:naughty_id, :user_id], unique: true
    end
  end
end
