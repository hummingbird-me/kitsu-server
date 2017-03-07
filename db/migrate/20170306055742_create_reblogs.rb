class CreateReblogs < ActiveRecord::Migration
  def change
    create_table :reblogs do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :post, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
