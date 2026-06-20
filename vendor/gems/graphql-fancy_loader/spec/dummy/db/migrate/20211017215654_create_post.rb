class CreatePost < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true, index: true
      t.string :title, null: false
      t.string :description

      t.timestamps
    end
  end
end
